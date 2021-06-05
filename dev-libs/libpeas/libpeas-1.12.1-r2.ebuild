# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"
GNOME2_EAUTORECONF="yes"
PYTHON_COMPAT=( python{3_8,3_9,3_10} )

inherit gnome2 multilib python-single-r1 virtualx

DESCRIPTION="A GObject plugins library"
HOMEPAGE="https://developer.gnome.org/libpeas/stable/"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="+gtk glade +python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=dev-libs/gobject-introspection-1.39:=
	glade? ( >=dev-util/glade-3.9.1:3.10 )
	gtk? ( >=x11-libs/gtk+-3:3[introspection] )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-python/pygobject-3.0.0:3[${PYTHON_MULTI_USEDEP}]
		')
	)
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.11
	>=dev-util/intltool-0.40
	virtual/pkgconfig

	dev-libs/gobject-introspection-common
	gnome-base/gnome-common
"
# eautoreconf needs gobject-introspection-common, gnome-common

PATCHES=(
	"${FILESDIR}"/${PN}-1.22.0-py38-support.patch # Fix py3.8 support, bug 702810
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	# Wtf, --disable-gcov, --enable-gcov=no, --enable-gcov, all enable gcov
	# What do we do about gdb, valgrind, gcov, etc?
	# --disable-seed because it's dead, bug #541890
	local myconf=(
		$(use_enable glade glade-catalog)
		$(use_enable gtk)
		--disable-deprecation
		--disable-seed
		--disable-static

		# py2 not supported anymore
		--disable-python2
		$(use_enable python python3)
	)

	gnome2_src_configure "${myconf[@]}"
}

src_test() {
	# FIXME: Tests fail because of some bug involving Xvfb and Gtk.IconTheme
	# DO NOT REPORT UPSTREAM, this is not a libpeas bug.
	# To reproduce:
	# >>> from gi.repository import Gtk
	# >>> Gtk.IconTheme.get_default().has_icon("gtk-about")
	# This should return True, it returns False for Xvfb
	virtx emake check
}
