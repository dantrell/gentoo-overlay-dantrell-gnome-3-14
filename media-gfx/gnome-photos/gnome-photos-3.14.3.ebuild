# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2

DESCRIPTION="Access, organize and share your photos on GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Photos"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="flickr upnp-av"

RESTRICT="test"

COMMON_DEPEND="
	>=app-misc/tracker-1:0=[miner-fs]
	>=dev-libs/glib-2.39.3:2
	dev-libs/libxml2
	gnome-base/gnome-desktop:3=
	>=gnome-base/librsvg-2.26.0
	>=dev-libs/libgdata-0.15.2:0=[gnome-online-accounts]
	media-libs/babl
	>=media-libs/gegl-0.2:0[cairo,raw]
	>=media-libs/grilo-0.2.6:0.2=
	>=media-libs/exempi-1.99.5:2
	media-libs/lcms:2
	>=media-libs/libexif-0.6.14
	>=net-libs/gnome-online-accounts-3.8:=
	>=net-libs/libgfbgraph-0.2.1:0.2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.13.2:3
"
# gnome-online-miners is also used for google, facebook, DLNA - not only flickr
# but out of all the grilo-plugins, only upnp-av and flickr get used, which have USE flags here,
# so don't pull it always, but only if either USE flag is enabled
RDEPEND="${COMMON_DEPEND}
	net-misc/gnome-online-miners[flickr?]
	upnp-av? ( media-plugins/grilo-plugins:0.2[upnp-av] )
	flickr? ( media-plugins/grilo-plugins:0.2[flickr] )
"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-util/desktop-file-utils
	>=dev-util/intltool-0.50.1
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure --disable-dogtail
}
