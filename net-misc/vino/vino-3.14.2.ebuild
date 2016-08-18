# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="yes"

inherit autotools eutils gnome2

DESCRIPTION="An integrated VNC server for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/Vino"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="crypt gnome-keyring ipv6 jpeg ssl +telepathy zeroconf +zlib"
# bug #394611; tight encoding requires zlib encoding
REQUIRED_USE="jpeg? ( zlib )"

# cairo used in vino-fb
# libSM and libICE used in eggsmclient-xsmp
RDEPEND="
	>=dev-libs/glib-2.26:2
	>=dev-libs/libgcrypt-1.1.90:0=
	>=x11-libs/gtk+-3:3

	dev-libs/dbus-glib
	x11-libs/cairo:=
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXtst
	x11-libs/pango[X]

	>=x11-libs/libnotify-0.7.0:=

	crypt? ( >=dev-libs/libgcrypt-1.1.90:0= )
	gnome-keyring? ( app-crypt/libsecret )
	jpeg? ( virtual/jpeg:0= )
	ssl? ( >=net-libs/gnutls-2.2.0:= )
	telepathy? ( >=net-libs/telepathy-glib-0.18 )
	zeroconf? ( >=net-dns/avahi-0.6:=[dbus] )
	zlib? ( sys-libs/zlib:= )
"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	>=dev-util/intltool-0.50
	virtual/pkgconfig
	app-crypt/libsecret
"
# libsecret is always required at build time per bug 322763

src_prepare() {
	# From GNOME:
	# 	https://git.gnome.org/browse/vino/commit/?id=ccf0986fc8ec5c1770505435c28c6438847263ed
	# 	https://git.gnome.org/browse/vino/commit/?id=4d53f758db39da152b7156587fa6ef66acefe1d0
	# 	https://git.gnome.org/browse/vino/commit/?id=9fa956adc7af65be0828f68237e716bdc1edfad1
	epatch "${FILESDIR}"/${PN}-3.15.4-remove-obsolete-gsettings-conversion-file.patch
	epatch "${FILESDIR}"/${PN}-3.15.90-vino-upnp-use-gnetworkmonitor.patch
	epatch "${FILESDIR}"/${PN}-3.15.91-avoid-a-critical-eggsmclient-warning-on-startup.patch

	# Improve handling of name resolution failure (from 'master')
	epatch "${FILESDIR}"/${PN}-3.16.0-name-resolution.patch

	# Avoid a crash when showing the preferences (from 'master')
	epatch "${FILESDIR}"/${PN}-3.16.0-fix-crash.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable ipv6) \
		$(use_with crypt gcrypt) \
		$(use_with gnome-keyring secret) \
		$(use_with jpeg) \
		$(use_with ssl gnutls) \
		$(use_with telepathy) \
		$(use_with zeroconf avahi) \
		$(use_with zlib)
}
