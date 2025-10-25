import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation

    property bool cfg_transparentBackground: false
    property bool cfg_mouseInteraction: true
    property int cfg_particleSpeed: 30
    property int cfg_interactionRadius: 150

    Plasmoid.backgroundHints: cfg_transparentBackground ?
    PlasmaCore.Types.NoBackground :
    (PlasmaCore.Types.DefaultBackground | PlasmaCore.Types.ConfigurableBackground)

    fullRepresentation: Item {
        id: mainItem

        Layout.minimumWidth: 300
        Layout.minimumHeight: 200
        Layout.preferredWidth: 600
        Layout.preferredHeight: 400

        Canvas {
            id: canvas
            anchors.fill: parent

            property var particles: []
            property point mousePos: Qt.point(0, 0)
            property bool isInitialized: false

            property var particleData: [
                {x: 202, y: 78, size: 9, color: "#ed9d33"},
                {x: 348, y: 83, size: 9, color: "#d44d61"},
                {x: 256, y: 69, size: 9, color: "#4f7af2"},
                {x: 214, y: 59, size: 9, color: "#ef9a1e"},
                {x: 265, y: 36, size: 9, color: "#4976f3"},
                {x: 300, y: 78, size: 9, color: "#269230"},
                {x: 294, y: 59, size: 9, color: "#1f9e2c"},
                {x: 45, y: 88, size: 9, color: "#1c48dd"},
                {x: 268, y: 52, size: 9, color: "#2a56ea"},
                {x: 73, y: 83, size: 9, color: "#3355d8"},
                {x: 294, y: 6, size: 9, color: "#36b641"},
                {x: 235, y: 62, size: 9, color: "#2e5def"},
                {x: 353, y: 42, size: 8, color: "#d53747"},
                {x: 336, y: 52, size: 8, color: "#eb676f"},
                {x: 208, y: 41, size: 8, color: "#f9b125"},
                {x: 321, y: 70, size: 8, color: "#de3646"},
                {x: 8, y: 60, size: 8, color: "#2a59f0"},
                {x: 180, y: 81, size: 8, color: "#eb9c31"},
                {x: 146, y: 65, size: 8, color: "#c41731"},
                {x: 145, y: 49, size: 8, color: "#d82038"},
                {x: 246, y: 34, size: 8, color: "#5f8af8"},
                {x: 169, y: 69, size: 8, color: "#efa11e"},
                {x: 273, y: 99, size: 8, color: "#2e55e2"},
                {x: 248, y: 120, size: 8, color: "#4167e4"},
                {x: 294, y: 41, size: 8, color: "#0b991a"},
                {x: 267, y: 114, size: 8, color: "#4869e3"},
                {x: 78, y: 67, size: 8, color: "#3059e3"},
                {x: 294, y: 23, size: 8, color: "#10a11d"},
                {x: 117, y: 83, size: 8, color: "#cf4055"},
                {x: 137, y: 80, size: 8, color: "#cd4359"},
                {x: 14, y: 71, size: 8, color: "#2855ea"},
                {x: 331, y: 80, size: 8, color: "#ca273c"},
                {x: 25, y: 82, size: 8, color: "#2650e1"},
                {x: 233, y: 46, size: 8, color: "#4a7bf9"},
                {x: 73, y: 13, size: 8, color: "#3d65e7"},
                {x: 327, y: 35, size: 6, color: "#f47875"},
                {x: 319, y: 46, size: 6, color: "#f36764"},
                {x: 256, y: 81, size: 6, color: "#1d4eeb"},
                {x: 244, y: 88, size: 6, color: "#698bf1"},
                {x: 194, y: 32, size: 6, color: "#fac652"},
                {x: 97, y: 56, size: 6, color: "#ee5257"},
                {x: 105, y: 75, size: 6, color: "#cf2a3f"},
                {x: 42, y: 4, size: 6, color: "#5681f5"},
                {x: 10, y: 27, size: 6, color: "#4577f6"},
                {x: 166, y: 55, size: 6, color: "#f7b326"},
                {x: 266, y: 88, size: 6, color: "#2b58e8"},
                {x: 178, y: 34, size: 6, color: "#facb5e"},
                {x: 100, y: 65, size: 6, color: "#e02e3d"},
                {x: 343, y: 32, size: 6, color: "#f16d6f"},
                {x: 59, y: 5, size: 6, color: "#507bf2"},
                {x: 27, y: 9, size: 6, color: "#5683f7"},
                {x: 233, y: 116, size: 6, color: "#3158e2"},
                {x: 123, y: 32, size: 6, color: "#f0696c"},
                {x: 6, y: 38, size: 6, color: "#3769f6"},
                {x: 63, y: 62, size: 6, color: "#6084ef"},
                {x: 6, y: 49, size: 6, color: "#2a5cf4"},
                {x: 108, y: 36, size: 6, color: "#f4716e"},
                {x: 169, y: 43, size: 6, color: "#f8c247"},
                {x: 137, y: 37, size: 6, color: "#e74653"},
                {x: 318, y: 58, size: 6, color: "#ec4147"},
                {x: 226, y: 100, size: 5, color: "#4876f1"},
                {x: 101, y: 46, size: 5, color: "#ef5c5c"},
                {x: 226, y: 108, size: 5, color: "#2552ea"},
                {x: 17, y: 17, size: 5, color: "#4779f7"},
                {x: 232, y: 93, size: 5, color: "#4b78f1"}
            ]

            MouseArea {
                anchors.fill: parent
                hoverEnabled: cfg_mouseInteraction

                onPositionChanged: function(mouse) {
                    if (cfg_mouseInteraction) {
                        canvas.mousePos = Qt.point(mouse.x, mouse.y)
                    }
                }

                onExited: {
                    canvas.mousePos = Qt.point(-1000, -1000)
                }
            }

            function initParticles() {
                particles = []

                for (let i = 0; i < particleData.length; i++) {
                    let data = particleData[i]
                    let offsetX = width / 2 - 180
                    let offsetY = height / 2 - 65

                    let particle = {
                        x: offsetX + data.x,
                        y: offsetY + data.y,
                        z: 1.0,

                        originalX: offsetX + data.x,
                        originalY: offsetY + data.y,

                        targetX: offsetX + data.x,
                        targetY: offsetY + data.y,
                        targetZ: 1.0,

                        velX: 0.0,
                        velY: 0.0,
                        velZ: 0.0,

                        baseSize: data.size,
                        radius: data.size,
                        color: data.color,

                        friction: 0.8,
                        springStrength: 0.1
                    }

                    particles.push(particle)
                }

                isInitialized = true
            }

            function updateParticles() {
                if (!isInitialized) return

                    for (let i = 0; i < particles.length; i++) {
                        let p = particles[i]

                        let dx = mousePos.x - p.x
                        let dy = mousePos.y - p.y
                        let distance = Math.sqrt(dx * dx + dy * dy)

                        if (distance < cfg_interactionRadius && cfg_mouseInteraction) {
                            p.targetX = p.x - dx
                            p.targetY = p.y - dy
                        } else {
                            p.targetX = p.originalX
                            p.targetY = p.originalY
                        }

                        let deltaX = p.targetX - p.x
                        let accelX = deltaX * p.springStrength
                        p.velX += accelX
                        p.velX *= p.friction
                        p.x += p.velX

                        let deltaY = p.targetY - p.y
                        let accelY = deltaY * p.springStrength
                        p.velY += accelY
                        p.velY *= p.friction
                        p.y += p.velY

                        let distanceFromOriginal = Math.sqrt(
                            Math.pow(p.originalX - p.x, 2) +
                            Math.pow(p.originalY - p.y, 2)
                        )
                        p.targetZ = distanceFromOriginal / 100 + 1

                        let deltaZ = p.targetZ - p.z
                        let accelZ = deltaZ * p.springStrength
                        p.velZ += accelZ
                        p.velZ *= p.friction
                        p.z += p.velZ

                        p.radius = p.baseSize * p.z
                        if (p.radius < 1) p.radius = 1
                    }
            }

            onPaint: {
                if (!isInitialized) return

                    let ctx = canvas.getContext('2d')
                    ctx.clearRect(0, 0, width, height)

                    for (let i = 0; i < particles.length; i++) {
                        let p = particles[i]

                        ctx.fillStyle = p.color
                        ctx.beginPath()
                        ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2)
                        ctx.fill()
                    }
            }

            onWidthChanged: {
                if (isInitialized) {
                    initParticles()
                }
            }

            onHeightChanged: {
                if (isInitialized) {
                    initParticles()
                }
            }

            Component.onCompleted: {
                initParticles()
            }
        }

        Timer {
            id: animationTimer
            interval: Math.round(1000 / cfg_particleSpeed)
            running: true
            repeat: true

            onTriggered: {
                canvas.updateParticles()
                canvas.requestPaint()
            }
        }
    }
}
