# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit autotools gnome2 virtualx

DESCRIPTION="GNOME webbrowser based on Webkit"
HOMEPAGE="https://wiki.gnome.org/Apps/Web https://gitlab.gnome.org/GNOME/epiphany"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="test"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=dev-libs/glib-2.38.0:2[dbus]
	>=x11-libs/gtk+-3.13.0:3
	>=net-libs/webkit-gtk-2.13.2:4=
	x11-libs/libwnck:3
	x11-libs/libX11
	>=app-crypt/gcr-3.5.5:0=[gtk]
	>=gnome-base/gnome-desktop-2.91.2:3=
	>=x11-libs/libnotify-0.5.1:=
	>=app-crypt/libsecret-0.14
	>=net-libs/libsoup-2.48:2.4
	>=dev-libs/libxml2-2.6.12:2
	>=dev-libs/libxslt-1.1.7
	dev-db/sqlite:3
	>=net-dns/avahi-0.6.22[dbus]
	>=app-text/iso-codes-0.35
	>=gnome-base/gsettings-desktop-schemas-0.0.1
"
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
"
# paxctl needed for bug #407085
# eautoreconf requires gnome-common-3.5.5
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	>=gnome-base/gnome-common-3.6
	>=dev-util/intltool-0.50
	dev-util/itstool
	sys-apps/paxctl
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	# https://bugzilla.gnome.org/show_bug.cgi?id=751591
	"${FILESDIR}"/${PN}-3.14.0-unittest-1.patch

	# https://bugzilla.gnome.org/show_bug.cgi?id=751593
	"${FILESDIR}"/${PN}-3.14.0-unittest-2.patch

	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/epiphany/-/commit/88f3ef095ec13a9e08ec31a0f145b72fea62fe60
	"${FILESDIR}"/${PN}-3.14.2-update-for-webkitgtk-2-14-unstable-dom-api-abi-break.patch
)

src_prepare() {
	# Fix missing symbol in webextension.so, bug #728972
	eapply "${FILESDIR}"/${PN}-3.14.0-missing-symbol.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# Many years have passed since gecko based epiphany went away,
	# hence, stop relying on nss for migrating from that versions.
	gnome2_src_configure \
		--disable-nss \
		--enable-shared \
		--disable-static \
		--with-distributor-name=Gentoo \
		$(use_enable test tests)
}

src_test() {
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die
	GSETTINGS_SCHEMA_DIR="${S}/data" virtx emake check
}
