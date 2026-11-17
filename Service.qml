pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import qs.Commons
import qs.Ui
import "config/MenuEntries.js" as MenuEntries

// OmaClick — right-click context menu for the desktop, plus the wallpaper
// gestures the wallpaper renderer used to receive directly.
//
// The wallpaper's own surface sits in the background layer, so a second surface
// in the same layer, created after it, takes pointer input on the bare desktop
// without covering any window or the desktop widgets on the bottom layer.
Item {
  id: root

  property var shell
  property var manifest

  property bool menuOpen: false
  property var menuScreen: null
  property real menuX: 0
  property real menuY: 0

  // Row metrics follow Omarchy's own type scale, so a larger
  // `omarchy display text size` grows the menu instead of clipping it.
  readonly property real textScale: Math.max(1, Style.fontScale)
  readonly property int rowHeight: Math.round(32 * textScale)
  readonly property int separatorHeight: Math.round(9 * textScale)
  readonly property int cardWidth: Math.round(236 * textScale)
  readonly property var entries: MenuEntries.entries
  readonly property int cardHeight: {
    var height = 12
    for (var i = 0; i < entries.length; i++)
      height += entries[i].separator ? separatorHeight : rowHeight
    return height
  }

  function openMenu(screen, x, y) {
    menuScreen = screen
    menuX = Math.round(x)
    menuY = Math.round(y)
    menuOpen = true
  }

  function closeMenu() {
    menuOpen = false
  }

  function runEntry(entry) {
    menuOpen = false
    if (entry && entry.command) Util.execDetached(entry.command)
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: desktopSurface

      required property var modelData

      screen: modelData
      anchors { top: true; bottom: true; left: true; right: true }
      color: "transparent"
      WlrLayershell.namespace: "omaclick-desktop-input"
      WlrLayershell.layer: WlrLayer.Bottom
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      exclusionMode: ExclusionMode.Ignore

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: function(mouse) {
          if (mouse.button === Qt.RightButton) {
            root.openMenu(modelData, mouse.x, mouse.y)
            mouse.accepted = true
          }
        }

        // The wallpaper surface underneath never sees these gestures, so its
        // two double-clicks are kept working from here.
        onDoubleClicked: function(mouse) {
          if (mouse.button === Qt.LeftButton)
            Util.execDetached(MenuEntries.wallpaperCommand)
          else if (mouse.button === Qt.RightButton)
            Util.execDetached(MenuEntries.themeCommand)
          mouse.accepted = true
        }
      }
    }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: menuWindow

      required property var modelData

      readonly property real cardX: Math.round(Math.max(8, Math.min(root.menuX, modelData.width - root.cardWidth - 8)))
      readonly property real cardY: root.menuY + root.cardHeight + 8 > modelData.height
        ? Math.round(Math.max(8, root.menuY - root.cardHeight))
        : Math.round(root.menuY)

      screen: modelData
      visible: root.menuOpen && root.menuScreen === modelData
      // The surface is the card itself; a full-screen overlay with a Region
      // mask put the pointer outside the surface, so presses never reached the
      // rows.
      anchors { top: true; left: true }
      margins { top: menuWindow.cardY; left: menuWindow.cardX }
      implicitWidth: root.cardWidth
      implicitHeight: root.cardHeight
      color: "transparent"
      WlrLayershell.namespace: "omaclick-desktop-menu"
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
      exclusionMode: ExclusionMode.Ignore

      onVisibleChanged: if (visible) card.forceActiveFocus()

      HyprlandFocusGrab {
        active: menuWindow.visible
        windows: [menuWindow]
        onCleared: root.closeMenu()
      }

      BorderSurface {
        id: card

        anchors.fill: parent
        color: Color.popups.background
        borderSpec: Border.surfaceSpec("popups", "border", Color.popups.border, 1)
        radius: Style.cornerRadius
        focus: true

        Keys.onEscapePressed: function(event) {
          root.closeMenu()
          event.accepted = true
        }

        Column {
          anchors.fill: parent
          anchors.margins: 6
          spacing: 1

          Repeater {
            model: root.entries

            delegate: Item {
              id: row

              // Bound component: model roles must be required properties.
              required property var modelData
              readonly property var entry: row.modelData
              readonly property bool separator: !!entry && entry.separator === true
              readonly property bool hovered: rowMouse.containsMouse && !separator

              width: parent ? parent.width : 0
              height: separator ? root.separatorHeight : root.rowHeight

              Rectangle {
                visible: row.separator
                anchors.verticalCenter: parent.verticalCenter
                x: 6
                width: parent.width - 12
                height: 1
                color: Color.popups.border
                opacity: 0.6
              }

              Rectangle {
                visible: row.hovered
                anchors.fill: parent
                radius: 6
                color: Color.accent
              }

              Text {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                visible: !row.separator
                text: row.separator ? "" : String(row.entry.label || "")
                elide: Text.ElideRight
                textFormat: Text.PlainText
                font.family: Style.font.menuFamily
                font.pixelSize: Style.font.body
                color: row.hovered ? Color.popups.background : Color.popups.text
              }

              MouseArea {
                id: rowMouse
                anchors.fill: parent
                enabled: !row.separator
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.runEntry(row.entry)
              }
            }
          }
        }
      }
    }
  }
}
