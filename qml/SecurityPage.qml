import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

NavigationPage {
    title: qsTr("Security")

    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Cable")
        component: Component {
            CablePage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Access")
        component: Component {
            AccessPage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Password")
        component: Component {
            PasswordPage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Grid")
        component: Component {
            GridPage {
            }
        }
    }
    NavigationItem {
        iconSource: "material-icons/grid_guides.svg"
        title: qsTr("Ground check")
        component: Component {
            GroundCheckPage {
            }
        }
    }
}
