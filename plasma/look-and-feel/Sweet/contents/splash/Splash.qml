import QtQuick
import org.kde.kirigami as Kirigami

Image {
    id: root
    source: "images/background.png"

    property int stage

    onStageChanged: {
        if (stage == 1) {
            introAnimation.running = true;
        }
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: 0
        TextMetrics {
            id: units
            text: "M"
            property int gridUnit: boundingRect.height
            property int largeSpacing: units.gridUnit
            property int smallSpacing: Math.max(2, gridUnit / 4)
        }

        Image {
            id: logo
            readonly property real size: units.gridUnit * 12

            anchors.centerIn: parent

            asynchronous: true
            // TODO: svg
            source: "images/sweetlogo.png"

            sourceSize.width: 135
            sourceSize.height: 135

            ParallelAnimation {
                running: true

                ScaleAnimator {
                    target: logo
                    from: 0
                    to: 1
                    duration: 700
                }

                SequentialAnimation {
                    loops: Animation.Infinite

                    OpacityAnimator {
                        target: logo
                        from: 0.75
                        to: 1
                        duration: 1200
                    }
                    OpacityAnimator {
                        target: logo
                        from: 1
                        to: 0.75
                        duration: 1200
                    }
                }
            }
        }

        Image {
            id: busyIndicator
            anchors.centerIn: parent
            asynchronous: true
            source: "images/busy.svg"
            sourceSize.height: 200
            sourceSize.width: 200
            RotationAnimator on rotation {
                id: rotationAnimator
                from: 0
                to: 360
                // Not using a standard duration value because we don't want the
                // animation to spin faster or slower based on the user's animation
                // scaling preferences; it doesn't make sense in this context
                duration: 2000
                loops: Animation.Infinite
                // Don't want it to animate at all if the user has disabled animations
                running: Kirigami.Units.longDuration > 1
            }
        }
    }

    OpacityAnimator {
        id: introAnimation
        running: false
        target: content
        from: 0
        to: 1
        duration: Kirigami.Units.veryLongDuration * 2
        easing.type: Easing.InOutQuad
    }
}
