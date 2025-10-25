import QtQuick
import QtQuick.Layouts
import QtMultimedia
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrolsaddons
import QtQuick.Controls

PlasmoidItem {
    width: 100
    height: 100

    Plasmoid.status: PlasmaCore.Types.HiddenStatus
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    AnimatedImage {
        id: animation
        source: "weenie.webp"
        smooth: true
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        width: Math.min(parent.width, implicitWidth)
        height: Math.min(parent.height, implicitHeight)
    }
}
