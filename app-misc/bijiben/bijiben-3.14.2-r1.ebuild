# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome2

DESCRIPTION="Note editor designed to remain simple to use"
HOMEPAGE="https://wiki.gnome.org/Apps/Bijiben"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE="zeitgeist"

RDEPEND="
	>=app-misc/tracker-1:=
	>=dev-libs/glib-2.28:2
	dev-libs/libxml2
	>=gnome-extra/evolution-data-server-3.13.90:=
	net-libs/gnome-online-accounts:=
	net-libs/webkit-gtk:3
	sys-apps/util-linux
	>=x11-libs/gtk+-3.11.4:3
	zeitgeist? ( gnome-extra/zeitgeist )
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	# From GNOME:
	# 	https://git.gnome.org/browse/bijiben/commit/?id=2c5a80bdc6a469153a7e8ca34ee6f4fa72e6a34a
	# 	https://git.gnome.org/browse/bijiben/commit/?id=d7c4e2a2f14444258348927c1c280f874e1adf2e
	# 	https://git.gnome.org/browse/bijiben/commit/?id=f54ba1a2a21c8034c8db417c874cb357f6b67b78
	eapply "${FILESDIR}"/${PN}-3.15.90-fix-build-with-evolution-data-server-3.13.90.patch
	eapply "${FILESDIR}"/${PN}-3.15.91-drop-dependency-on-evolution.patch
	eapply "${FILESDIR}"/${PN}-3.15.91-build-use-intltool-to-translate-gsettings-schema-file.patch

	# Fix zeitgeist automagic dependency
	# https://bugzilla.gnome.org/show_bug.cgi?id=756013
	eapply "${FILESDIR}"/${PN}-3.18.2-zeitgeist-automagic.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable zeitgeist) \
		--disable-update-mimedb
}
