# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_10,3_11,3_12,3_13} )

inherit autotools gnome2 pax-utils python-r1 vala

DESCRIPTION="git repository viewer for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Gitg"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="debug glade +python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# test if unbundling of libgd is possible
# Currently it seems not to be (unstable API/ABI)
RDEPEND="
	dev-libs/libgee:0.8[introspection]
	>=dev-libs/json-glib-0.16
	>=app-text/gtkspell-3.0.3:3
	>=dev-libs/glib-2.38:2[dbus]
	>=dev-libs/gobject-introspection-0.10.1:=
	dev-libs/libgit2:=[threads]

	>=dev-libs/libgit2-glib-0.22.0[ssh]
	<dev-libs/libgit2-glib-0.23.0

	>=dev-libs/libpeas-1.5.0[gtk]
	net-libs/libsoup:2.4
	>=gnome-base/gsettings-desktop-schemas-0.1.1
	>=net-libs/webkit-gtk-2.2:4[introspection]
	>=x11-libs/gtk+-3.12.0:3
	>=x11-libs/gtksourceview-3.10:3.0
	x11-themes/adwaita-icon-theme
	glade? ( >=dev-util/glade-3.2:3.10 )
	python? (
		${PYTHON_DEPS}
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=dev-libs/libgit2-glib-0.22.0[vala]
	>=dev-util/intltool-0.40
	gnome-base/gnome-common
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

PATCHES=(
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gitg/-/commit/a1f43c1c985e48b8c8ca941e3d1c8d1dcc19122a
	# 	https://gitlab.gnome.org/GNOME/gitg/-/commit/84eee97117fc358544095541d5a54eca7639bb0f
	"${FILESDIR}"/${PN}-3.14.1-libgit2-glib-0.22.0.patch
	"${FILESDIR}"/${PN}-3.14.1-unambiguate-references-to-assert-no-error.patch
)

pkg_setup() {
	use python && [[ ${MERGE_TYPE} != binary ]] && python_setup
}

src_prepare() {
	sed \
		-e '/CFLAGS/s:-g::g' \
		-e '/CFLAGS/s:-O0::g' \
		-i configure.ac || die

	sed \
		-e 's/name="WebKit2" version="3.0"/name="WebKit2" version="4.0"/' \
		-i Gitg-1.0.gir || die

	eautoreconf
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--disable-deprecations \
		$(use_enable debug) \
		$(use_enable glade glade-catalog) \
		$(use_enable python)
}

src_install() {
	# -j1: bug #???
	gnome2_src_install -j1

	if use python ; then
		install_gi_override() {
			python_moduleinto "$(python_get_sitedir)/gi/overrides"
			python_domodule "${S}"/libgitg-ext/GitgExt.py
		}
		python_foreach_impl install_gi_override
	fi

	if has_version 'net-libs/webkit-gtk:4[jit]'; then
		# needed on hardened/PaX, see github pr 910 and bug #527334
		pax-mark m "${ED}usr/bin/gitg"
	fi
}
