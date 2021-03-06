# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 virtualx

DESCRIPTION="Gnome install & update software"
HOMEPAGE="https://wiki.gnome.org/Apps/Software"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE=""

RESTRICT="test"

RDEPEND="
	>=app-admin/packagekit-base-1
	dev-db/sqlite:3
	>=dev-libs/appstream-glib-0.3.4:0
	>=dev-libs/glib-2.39.1:2
	gnome-base/gnome-desktop:3=
	>=gnome-base/gsettings-desktop-schemas-3.11.5
	net-libs/libsoup:2.4
	sys-auth/polkit
	>=x11-libs/gtk+-3.14.1:3
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

src_prepare() {
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gnome-software/commit/4de9bc66873f6bb054fe0b4d26f2b24079c8d354
	eapply "${FILESDIR}"/${PN}-3.14.7-support-the-new-appstreamglib-v5.0-api.patch

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-man \
		--disable-dogtail
}
