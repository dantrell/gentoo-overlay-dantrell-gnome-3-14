# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit autotools bash-completion-r1 gnome2

DESCRIPTION="GNOME's main interface to configure various aspects of the desktop"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-control-center"

LICENSE="GPL-2+"
SLOT="2"
KEYWORDS="*"

IUSE="+bluetooth ck +colord +cups debug elogind +gnome-online-accounts +ibus input_devices_wacom kerberos libinput networkmanager systemd v4l vanilla-datetime vanilla-hostname wayland"
REQUIRED_USE="
	?? ( ck elogind systemd )
	wayland? ( || ( elogind systemd ) )
"

# False positives caused by nested configure scripts
QA_CONFIGURE_OPTIONS=".*"

# gnome-session-2.91.6-r1 is needed so that 10-user-dirs-update is run at login
# kerberos unfortunately means mit-krb5; build fails with heimdal
COMMON_DEPEND="
	>=dev-libs/glib-2.39.91:2[dbus]
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.13:3[X,wayland?]
	>=gnome-base/gsettings-desktop-schemas-3.13.91
	>=gnome-base/gnome-desktop-3.11.3:3=
	>=gnome-base/gnome-settings-daemon-3.8.3[colord?]

	>=dev-libs/libpwquality-1.2.2
	dev-libs/libxml2:2
	gnome-base/libgtop:2=
	media-libs/fontconfig
	>=sys-apps/accountsservice-0.6.33

	>=media-libs/libcanberra-0.13[gtk3]
	>=media-sound/pulseaudio-2[glib]
	>=sys-auth/polkit-0.97
	>=sys-power/upower-0.99:=
	>=x11-libs/libnotify-0.7.3:0=

	x11-apps/xmodmap
	x11-libs/cairo
	x11-libs/libX11
	>=x11-libs/libXi-1.2

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.11.1:= )
	colord? (
		net-libs/libsoup:2.4
		>=x11-misc/colord-0.1.34:0=
		>=x11-libs/colord-gtk-0.1.24 )
	cups? (
		>=net-print/cups-1.4[dbus]
		>=net-fs/samba-4.0.0[client]
	)
	gnome-online-accounts? (
		>=media-libs/grilo-0.2.6:0.2
		>=net-libs/gnome-online-accounts-3.9.90:= )
	ibus? ( >=app-i18n/ibus-1.5.2 )
	kerberos? ( app-crypt/mit-krb5 )
	networkmanager? (
		>=gnome-extra/nm-applet-0.9.7.995
		>=net-misc/networkmanager-0.9.8:=[modemmanager]
		>=net-misc/modemmanager-0.7.990 )
	v4l? (
		media-libs/gstreamer:1.0
		media-libs/clutter-gtk:1.0
		>=media-video/cheese-3.5.91 )
	input_devices_wacom? (
		>=dev-libs/libwacom-0.7
		>=media-libs/clutter-1.11.3:1.0
		media-libs/clutter-gtk:1.0
		>=x11-libs/libXi-1.2 )
"
# <gnome-color-manager-3.1.2 has file collisions with g-c-c-3.1.x
# libgnomekbd needed only for gkbd-keyboard-display tool
#
# mouse panel needs a concrete set of X11 drivers at runtime, bug #580474
# Also we need newer driver versions to allow wacom and libinput drivers to
# not collide
#
# system-config-printer provides org.fedoraproject.Config.Printing service and interface
# cups-pk-helper provides org.opensuse.cupspkhelper.mechanism.all-edit policykit helper policy
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
	colord? ( >=gnome-extra/gnome-color-manager-3 )
	cups? (
		app-admin/system-config-printer
		net-print/cups-pk-helper )
	input_devices_wacom? ( gnome-base/gnome-settings-daemon[input_devices_wacom] )
	ibus? ( >=gnome-base/libgnomekbd-3 )
	wayland? ( libinput? ( dev-libs/libinput ) )
	!wayland? (
		libinput? ( >=x11-drivers/xf86-input-libinput-0.19.0 )
		input_devices_wacom? ( >=x11-drivers/xf86-input-wacom-0.33.0 ) )

	!<gnome-base/gdm-2.91.94
	!<gnome-extra/gnome-color-manager-3.1.2
	!gnome-extra/gnome-media[pulseaudio]
	!<gnome-extra/gnome-media-2.32.0-r300
	!<net-wireless/gnome-bluetooth-3.3.2

	ck? ( >=sys-power/upower-0.99:=[ck] )
	elogind? ( sys-auth/elogind )
	systemd? ( >=sys-apps/systemd-186:0= )
	!systemd? ( app-admin/openrc-settingsd )
"
# PDEPEND to avoid circular dependency
PDEPEND=">=gnome-base/gnome-session-2.91.6-r1"

DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto

	dev-libs/libxml2:2
	dev-libs/libxslt
	>=dev-util/intltool-0.40.1
	>=sys-devel/gettext-0.17
	virtual/pkgconfig

	gnome-base/gnome-common
"
# Needed for autoreconf
#	gnome-base/gnome-common

src_prepare() {
	# Make some panels and dependencies optional; requires eautoreconf
	# https://bugzilla.gnome.org/686840, 697478, 700145
	eapply "${FILESDIR}"/${PN}-3.14.0-optional.patch

	# Fix some absolute paths to be appropriate for Gentoo
	eapply "${FILESDIR}"/${PN}-3.10.2-gentoo-paths.patch

	# From GNOME:
	# 	https://bugzilla.gnome.org/show_bug.cgi?id=753643
	cp "${FILESDIR}"/timezones/*.png panels/datetime/data/ || die
	eapply "${FILESDIR}"/${PN}-3.17.3-datetime-update-timezones-for-new-pyongyang-time.patch

	if use ck; then
		# From Funtoo:
		# 	https://bugs.funtoo.org/browse/FL-1329
		eapply "${FILESDIR}"/${PN}-3.14.5-restore-deprecated-code.patch
	fi

	if ! use vanilla-datetime; then
		# From Funtoo:
		# 	https://bugs.funtoo.org/browse/FL-1389
		eapply "${FILESDIR}"/${PN}-3.14.5-disable-automatic-datetime-and-timezone-options.patch
	fi

	if ! use vanilla-hostname; then
		# From Funtoo:
		# 	https://bugs.funtoo.org/browse/FL-1391
		eapply "${FILESDIR}"/${PN}-3.14.1-disable-changing-hostname.patch
	fi

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-update-mimedb \
		--disable-static \
		--enable-documentation \
		$(use_enable bluetooth) \
		$(use_enable ck deprecated) \
		$(use_enable colord color) \
		$(use_enable cups) \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable gnome-online-accounts goa) \
		$(use_enable ibus) \
		$(use_enable kerberos) \
		$(use_enable networkmanager) \
		$(use_with v4l cheese) \
		$(use_enable input_devices_wacom wacom)
}

src_install() {
	gnome2_src_install completiondir="$(get_bashcompdir)"
}
