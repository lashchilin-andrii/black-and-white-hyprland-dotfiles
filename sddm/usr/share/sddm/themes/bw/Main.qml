import QtQuick 2.15
import QtGraphicalEffects 1.15
import SddmComponents 2.0

Rectangle {
    id: container
    width: 1920
    height: 1200
    color: colorBg

    property string fontFamily: "Noto Sans Mono"
    property color colorBg: "#000000"
    property color colorBgOverlay: "#cc000000"
    property color textColor: "#ffffff"
    property color textSecondary: "#b3ffffff"
    property color colorHover: "#33ffffff"
    property color colorError: "#f38ba8"
    property color borderFocused: "#4dffffff"

    property int sessionIndex: sessionModel.lastIndex
    
    property bool isInputFocused: nameInput.activeFocus || passwordInput.activeFocus

    // Base Wallpaper Image
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: "https://unsplash.it/2560/1600?night"
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        visible: false // Hidden because FastBlur renders it directly
    }

    // Blurred Wallpaper Overlay
    FastBlur {
        anchors.fill: backgroundImage
        source: backgroundImage
        radius: container.isInputFocused ? 40 : 0

        Behavior on radius {
            NumberAnimation {
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }
    }

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        function onLoginFailed() {
            passwordInput.text = ""
            errorMessage.text = textConstants.loginFailed
        }
    }

    // Centered Interface Container
    Column {
        anchors.centerIn: parent
        width: 400
        spacing: 40

        // --- TIME & DATE ---
        Column {
            width: parent.width
            spacing: -30

            Text {
                id: timeText
                anchors.horizontalCenter: parent.horizontalCenter
                color: textColor
                font.family: fontFamily
                font.pixelSize: 180
                font.bold: true

                function updateTime() {
                    timeText.text = Qt.formatDateTime(new Date(), "HH:mm")
                }
            }

            Text {
                id: dateText
                anchors.horizontalCenter: parent.horizontalCenter
                color: textSecondary
                font.family: fontFamily
                font.pixelSize: 36

                function updateDate() {
                    dateText.text = Qt.formatDateTime(new Date(), "dddd, MMMM d")
                }
            }

            Timer {
                interval: 1000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    timeText.updateTime()
                    dateText.updateDate()
                }
            }
        }

        // --- INPUT FIELDS ---
        Column {
            width: parent.width
            spacing: 12

            // Minimal Username Field
            Rectangle {
                width: parent.width
                height: 44
                color: "transparent"
                radius: 8

                TextInput {
                    id: nameInput
                    anchors.fill: parent
                    anchors.margins: 8
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: textSecondary
                    clip: true
                    font.family: fontFamily
                    font.pixelSize: 18
                    text: userModel.lastUser
                    selectByMouse: true

                    KeyNavigation.tab: passwordInput

                    Keys.onPressed: function(event) {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(nameInput.text, passwordInput.text, sessionIndex)
                            event.accepted = true
                        }
                    }
                }
            }

            // Minimal Password Field
            Rectangle {
                width: parent.width
                height: 44
                color: "transparent"
                radius: 8

                TextInput {
                    id: passwordInput
                    anchors.fill: parent
                    anchors.margins: 8
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    echoMode: TextInput.Password
                    color: textSecondary
                    clip: true
                    font.family: fontFamily
                    font.pixelSize: 18
                    font.letterSpacing: 6
                    selectByMouse: true

                    passwordCharacter: "*"

                    Keys.onPressed: function(event) {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(nameInput.text, passwordInput.text, sessionIndex)
                            event.accepted = true
                        }
                    }
                }
            }

            Text {
                id: errorMessage
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                color: colorError
                font.family: fontFamily
                font.pixelSize: 14
            }
        }
    }

    // --- POWER MENU (Minimal Bottom-Right Trigger) ---
    Item {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 30
        width: 40
        height: 40

        Rectangle {
            id: powerPopup
            width: childrenRect.width + 8
            height: childrenRect.height + 8
            radius: 8
            color: colorBgOverlay
            border.color: borderFocused
            border.width: 1
            visible: false
            anchors.right: parent.right
            anchors.bottom: powerButton.top
            anchors.bottomMargin: 8

            Column {
                x: 4
                y: 4
                width: 112
                spacing: 2

                Rectangle {
                    width: parent.width
                    height: 32
                    radius: 4
                    color: suspendMouse.containsMouse ? colorHover : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "Suspend"
                        color: textColor
                        font.family: fontFamily
                        font.pixelSize: 13
                    }

                    MouseArea {
                        id: suspendMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            powerPopup.visible = false
                            sddm.suspend()
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 32
                    radius: 4
                    color: rebootMouse.containsMouse ? colorHover : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "Reboot"
                        color: textColor
                        font.family: fontFamily
                        font.pixelSize: 13
                    }

                    MouseArea {
                        id: rebootMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            powerPopup.visible = false
                            sddm.reboot()
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 32
                    radius: 4
                    color: shutdownMouse.containsMouse ? colorHover : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "Shutdown"
                        color: textColor
                        font.family: fontFamily
                        font.pixelSize: 13
                    }

                    MouseArea {
                        id: shutdownMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            powerPopup.visible = false
                            sddm.powerOff()
                        }
                    }
                }
            }
        }

        Rectangle {
            id: powerButton
            width: powerText.implicitWidth + 20
            height: powerText.implicitHeight + 16
            radius: 8
            color: powerBtnMouse.containsMouse ? colorHover : "transparent"

            anchors.right: parent.right
            anchors.bottom: parent.bottom

            Text {
                id: powerText
                anchors.centerIn: parent
                text: "Menu"
                color: textSecondary
                font.family: fontFamily
                font.pixelSize: 16
            }

            MouseArea {
                id: powerBtnMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: powerPopup.visible = !powerPopup.visible
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: powerPopup.visible = false
    }

    Component.onCompleted: {
        if (nameInput.text === "")
            nameInput.forceActiveFocus()
        else
            passwordInput.forceActiveFocus()
    }
}