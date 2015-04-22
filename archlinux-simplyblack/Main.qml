import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: container
    width: 1600
    height: 900

    Connections {
        target: sddm

        onLoginSucceeded: {
            errorMessage.color = "steelblue"
            errorMessage.text = qsTr("Login succeeded.")
        }

        onLoginFailed: {
            errorMessage.color = "red"
            errorMessage.text = qsTr("Login failed.")
        }
    }

    Rectangle {
        id: rectangle1
        property variant geometry: screenModel.geometry(screenModel.primary)
        color: "transparent"
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent

        Image {
            id: background
            anchors.fill: parent
            source: "background.png"
        }

        Image {
            id: archlinux
            width: 450
            height: 150
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -100
            anchors.horizontalCenterOffset: 0
            fillMode: Image.PreserveAspectFit
            transformOrigin: Item.Center
            source: "archlinux.png"
        }

        Text {
            color: "#ffffff"
            text: qsTr("Welcome to ") + sddm.hostName
            anchors.left: parent.left
            anchors.leftMargin: 14
            anchors.top: parent.top
            anchors.topMargin: 15
            font.pixelSize: 24
        }

        Column {
            id: column1
            width: 510
            height: 245
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 200
            spacing: 12

            Column {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 4
                Text {
                    id: lblName
                    width: 60
                    color: "#ffffff"
                    text: qsTr("User name")
                    font.bold: true
                    font.pixelSize: 12
                }

                TextBox {
                    id: name
                    width: parent.width; height: 30
                    text: userModel.lastUser
                    font.pixelSize: 14

                    KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password

                    Keys.onPressed: {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(name.text, password.text, session.index)
                            event.accepted = true
                        }
                    }
                }
            }

            Column {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                spacing : 4
                Text {
                    id: lblPassword
                    width: 60
                    color: "#ffffff"
                    text: qsTr("Password")
                    font.bold: true
                    font.pixelSize: 12
                }

                TextBox {
                    id: password
                    width: parent.width; height: 30
                    font.pixelSize: 14

                    echoMode: TextInput.Password

                    KeyNavigation.backtab: name; KeyNavigation.tab: session

                    Keys.onPressed: {
                        if (event.key === Qt.Key_Return) {
                            sddm.login(name.text, password.text, session.index)
                            event.accepted = true
                        }
                    }
                }
            }

            Column {
                z: 100
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                spacing : 4
                Text {
                    id: lblSession
                    width: 60
                    color: "#ffffff"
                    text: qsTr("Session")
                    font.bold: true
                    font.pixelSize: 12
                }

                ComboBox {
                    id: session
                    width: parent.width; height: 30

                    arrowIcon: "angle-down.png"

                    model: sessionModel
                    index: sessionModel.lastIndex

                    KeyNavigation.backtab: password; KeyNavigation.tab: loginButton
                }
            }

            Column {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    id: errorMessage
                    color: "#0088cc"
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Enter your user name and password.")
                    font.pixelSize: 10
                }
            }

            Row {
                spacing: 4
                anchors.horizontalCenter: parent.horizontalCenter
                property int btnWidth: Math.max(loginButton.implicitWidth,
                                                shutdownButton.implicitWidth,
                                                rebootButton.implicitWidth, 80) + 8
                Button {
                    id: loginButton
                    text: textConstants.login
                    width: parent.btnWidth

                    onClicked: sddm.login(name.text, password.text, session.index)

                    KeyNavigation.backtab: layoutBox; KeyNavigation.tab: shutdownButton
                }

                Button {
                    id: shutdownButton
                    text: textConstants.shutdown
                    width: parent.btnWidth

                    onClicked: sddm.powerOff()

                KeyNavigation.backtab: loginButton; KeyNavigation.tab: rebootButton
                }

                Button {
                    id: rebootButton
                    text: textConstants.reboot
                    width: parent.btnWidth

                    onClicked: sddm.reboot()

                    KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: name
                }
            }
        }





    }

    Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }
}
