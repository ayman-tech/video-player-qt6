import QtQuick
import QtMultimedia
import QtQuick.Controls
import QtQuick.Dialogs

ApplicationWindow {
    width: 400
    height: 300
    color: "#4C4E52"
    visible: true
    title: "video player"
    VideoOutput {
        id: videoOutput
        anchors.fill: parent
        MouseArea {
            id: seekArea
            anchors.fill: parent
            onPressed: {
                var position = mouse.x / videoOutput.width
                videoPlayer.mediaObject.seek(position * videoPlayer.mediaObject.duration)
            }
        }
    }
    MediaPlayer {
        id: videoPlayer
        videoOutput: videoOutput
        activeAudioTrack: 1
        audioOutput: AudioOutput {}
    }

    Rectangle {
        id: controlBar
        width: parent.width
        height: 40
        color: "#333333"
        y: parent.height - height

        Button {
            id: playButton
            text: videoPlayer.playbackState === MediaPlayer.PlayingState ? "Pause" : "Play"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            onClicked: {
                if (videoPlayer.playbackState === MediaPlayer.PlayingState)
                    videoPlayer.pause()
                else
                    videoPlayer.play()
            }
        }
        Button{
            id: fileButton
            width: 50
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            text: "Open"
            onClicked: fileDialog.open()
        }
        Slider {
            id: progressSlider
            width: parent.width/1.5
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            from: 0
            to: videoPlayer.duration
            value: videoPlayer.position
            onValueChanged: videoPlayer.position = value
        }
    }
    FileDialog {
        id: fileDialog
        title: "Open Video"
        nameFilters: ["Video files (*.mp4 *.avi *.mkv)"]
        onAccepted: {
            videoPlayer.pause()
            videoPlayer.source = fileDialog.currentFile
            videoPlayer.position =0
            videoPlayer.play()
        }
    }
}
