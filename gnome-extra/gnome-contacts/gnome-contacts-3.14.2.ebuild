# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"
VALA_MAX_API_VERSION="0.26"

inherit gnome2 vala

DESCRIPTION="GNOME contact management application"
HOMEPAGE="https://wiki.gnome.org/Design/Apps/Contacts"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="v4l"

VALA_DEPEND="
	$(vala_depend)
	>=dev-libs/gobject-introspection-0.9.6:=
	dev-libs/folks[vala(+)]
	gnome-base/gnome-desktop:3=[introspection]
	gnome-extra/evolution-data-server[vala]
	net-libs/telepathy-glib[vala]
	x11-libs/libnotify[introspection]
"
# Configure is wrong; it needs cheese-3.5.91, not 3.3.91
RDEPEND="
	>=dev-libs/folks-0.9.5:=[eds,telepathy]
	>=dev-libs/glib-2.37.6:2
	>=dev-libs/libgee-0.10:0.8
	>=gnome-extra/evolution-data-server-3.5.3:=[gnome-online-accounts]
	>=gnome-base/gnome-desktop-3.0:3=
	net-libs/gnome-online-accounts:=
	>=net-libs/telepathy-glib-0.17.5
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2
	x11-libs/libnotify:=
	>=x11-libs/gtk+-3.12:3
	x11-libs/pango
	v4l? ( >=media-video/cheese-3.5.91:= )
"
DEPEND="${RDEPEND}
	${VALA_DEPEND}
	dev-libs/libxslt
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_prepare() {
	# Regenerate the pre-generated C sources, bug #471628
	if ! use v4l; then
		touch src/*.vala
	fi

	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gnome-contacts/-/commit/207bc1198e3a23ca12af51638781bfd0b50fae6f
	eapply "${FILESDIR}"/${PN}-3.15.90-contacts-types-avoid-ambiguous-liststore.patch

	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-man-pages \
		$(use_with v4l cheese)
}
