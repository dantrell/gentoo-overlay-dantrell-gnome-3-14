# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome.org

DESCRIPTION="Notification daemon"
HOMEPAGE="https://gitlab.gnome.org/Archive/notification-daemon"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	>=dev-libs/glib-2.27:2
	>=x11-libs/gtk+-3.8:3[X]
	sys-apps/dbus
	media-libs/libcanberra[gtk3]
	>=x11-libs/libnotify-0.7
	x11-libs/libX11
	!x11-misc/notify-osd
	!x11-misc/qtnotifydaemon
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/notification-daemon/commit/69bbecf9fde68cce13f8f25a89544d0f7757a9a5
	# 	https://gitlab.gnome.org/GNOME/notification-daemon/commit/4dbd90ebac1a3005137f57b027b5dff07d5032d5
	# 	https://gitlab.gnome.org/GNOME/notification-daemon/commit/6e472aa507939a60b9cd8be8c2428d37e10fd81c
	# 	https://gitlab.gnome.org/GNOME/notification-daemon/commit/72430ca9062719f1125cc9b1ff7171194325e775
	# 	https://gitlab.gnome.org/GNOME/notification-daemon/commit/3430a3425c44329073d1fb522c5661ea64c4eb38
	# 	https://gitlab.gnome.org/GNOME/notification-daemon/commit/659a0da0f4ceb9fe3dcf50096f96c6c267f3673f
	"${FILESDIR}"/${PN}-3.16.0-nd-notfification-fix-crash-when-hint-is-real-boolean.patch
	"${FILESDIR}"/${PN}-3.16.0-nd-notification-properly-check-if-gvariant-is-string.patch
	"${FILESDIR}"/${PN}-3.16.0-nd-bubble-fix-timeout.patch
	"${FILESDIR}"/${PN}-3.16.1-nd-bubble-reset-timeout-if-user-moves-mouse-over-bubble.patch
	"${FILESDIR}"/${PN}-3.16.1-nd-bubble-reset-timeout-when-updating-notification.patch
	"${FILESDIR}"/${PN}-3.16.1-fix-resident-notifications.patch
)

src_install() {
	default

	cat <<-EOF > "${T}"/org.freedesktop.Notifications.service
	[D-BUS Service]
	Name=org.freedesktop.Notifications
	Exec=/usr/libexec/notification-daemon
	EOF

	insinto /usr/share/dbus-1/services
	doins "${T}"/org.freedesktop.Notifications.service
}
