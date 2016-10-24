# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2

DESCRIPTION="GLib geocoding library that uses the Yahoo! Place Finder service"
HOMEPAGE="https://git.gnome.org/browse/geocode-glib"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="*"

IUSE="+introspection test"

# FIXME: need network #424719, recheck
# need various locales to be present
RESTRICT="test"

RDEPEND="
	>=dev-libs/glib-2.34:2
	>=dev-libs/json-glib-0.99.2[introspection?]
	gnome-base/gvfs[http]
	>=net-libs/libsoup-2.42:2.4[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.6.3:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.13
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"
# eautoreconf requires:
#	dev-libs/gobject-introspection-common
#	gnome-base/gnome-common

PATCHES=(
	# From GNOME:
	# 	https://git.gnome.org/browse/geocode-glib/commit/?id=7043600c142eeac178c604f6c40866b1a91230ff
	# 	https://git.gnome.org/browse/geocode-glib/commit/?id=eb7f87af516f864c89ed83d8236862f3f38f87e4
	# 	https://git.gnome.org/browse/geocode-glib/commit/?id=7a6e9ffbb3f54fa8dc8944056ebf3b5c9b1db1d0
	# 	https://git.gnome.org/browse/geocode-glib/commit/?id=005075f6a28c18f5196ba60ff07b888776af6dfc
	# 	https://git.gnome.org/browse/geocode-glib/commit/?id=f0f85d8d01c64c61dfef3d00af5b9e629e336213
	# 	https://git.gnome.org/browse/geocode-glib/commit/?id=3ce317a218c255b8a8025f8f2a6010ce500dc0ee
	"${FILESDIR}"/${PN}-3.15.3.1-forward-reverse-use-https-and-fix-the-cache.patch
	"${FILESDIR}"/${PN}-3.15.4-derive-street-address-format-from-locale.patch
	"${FILESDIR}"/${PN}-3.15.4-test-gcglib-add-test-of-address-format.patch
	"${FILESDIR}"/${PN}-3.15.4-only-expose-nl-address-postal-fmt-on-gnuc.patch
	"${FILESDIR}"/${PN}-3.15.4-use-glibc-when-checking-for-glibc-only-feature.patch
	"${FILESDIR}"/${PN}-3.20.1-use-uclibc-when-checking-for-glibc-features.patch
)

src_configure() {
	gnome2_src_configure $(use_enable introspection)
}

src_test() {
	export GVFS_DISABLE_FUSE=1
	export GIO_USE_VFS=gvfs
	ewarn "Tests require network access to http://where.yahooapis.com"
	dbus-launch emake check || die "tests failed"
}
