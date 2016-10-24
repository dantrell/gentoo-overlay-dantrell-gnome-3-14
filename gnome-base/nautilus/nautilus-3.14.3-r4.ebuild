# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes" # Needed with USE 'sendto'

inherit gnome2 readme.gentoo-r1 versionator virtualx

DESCRIPTION="A file manager for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Nautilus"

LICENSE="GPL-2+ LGPL-2+ FDL-1.1"
SLOT="0"
KEYWORDS="*"

# profiling?
IUSE="debug exif gnome +introspection packagekit +previewer sendto tracker vanilla-menu vanilla-rename xmp"

# FIXME: tests fails under Xvfb, but pass when building manually
# "FAIL: check failed in nautilus-file.c, line 8307"
RESTRICT="test"

# FIXME: selinux support is automagic
# Require {glib,gdbus-codegen}-2.30.0 due to GDBus API changes between 2.29.92
# and 2.30.0
COMMON_DEPEND="
	>=dev-libs/glib-2.35.3:2[dbus]
	>=x11-libs/pango-1.28.3
	>=x11-libs/gtk+-3.13.2:3[introspection?]
	>=dev-libs/libxml2-2.7.8:2
	>=gnome-base/gnome-desktop-3:3=

	gnome-base/dconf
	>=gnome-base/gsettings-desktop-schemas-3.8.0
	>=x11-libs/libnotify-0.7:=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender

	exif? ( >=media-libs/libexif-0.6.20 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.4:= )
	tracker? ( >=app-misc/tracker-0.16:= )
	xmp? ( >=media-libs/exempi-2.1.0 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	>=dev-util/gdbus-codegen-2.33
	>=dev-util/gtk-doc-am-1.4
	>=dev-util/intltool-0.40.1
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xproto
"
RDEPEND="${COMMON_DEPEND}
	packagekit? ( app-admin/packagekit-base )
	sendto? ( !<gnome-extra/nautilus-sendto-3.0.1 )
"

# For eautoreconf
#	gnome-base/gnome-common
#	dev-util/gtk-doc-am"

PDEPEND="
	gnome? ( x11-themes/adwaita-icon-theme )
	tracker? ( >=gnome-extra/nautilus-tracker-tags-0.12 )
	previewer? (
		>=gnome-extra/sushi-0.1.9
		>=media-video/totem-$(get_version_component_range 1-2) )
	sendto? ( >=gnome-extra/nautilus-sendto-3.0.1 )
	>=gnome-base/gvfs-1.14[gtk]
"
# Need gvfs[gtk] for recent:/// support

src_prepare() {
	if use previewer; then
		DOC_CONTENTS="nautilus uses gnome-extra/sushi to preview media files.
			To activate the previewer, select a file and press space; to
			close the previewer, press space again."
	fi

	if ! use vanilla-menu; then
		eapply "${FILESDIR}"/${PN}-3.14.3-reorder-context-menu.patch
	fi

	if ! use vanilla-rename; then
		eapply "${FILESDIR}"/${PN}-3.14.3-support-slow-double-click-to-rename.patch
	fi

	# Restore the nautilus-2.x Delete shortcut (Ctrl+Delete will still work);
	# bug #393663
	eapply "${FILESDIR}/${PN}-3.5.91-delete.patch"

	# From GNOME:
	# 	https://git.gnome.org/browse/nautilus/commit/?id=a0cbf72827b87a28fba47988957001a8b4fbddf5
	# 	https://git.gnome.org/browse/nautilus/commit/?id=45413c18167cddaefefc092b63ec75d8fadc6f50
	# 	https://git.gnome.org/browse/nautilus/commit/?id=bfe878e4313e21b4c539d95a88d243065d30fc2c
	# 	https://git.gnome.org/browse/nautilus/commit/?id=079d349206c2dd182df82e4b26e3e23c9b7a75c4
	# 	https://git.gnome.org/browse/nautilus/commit/?id=618f6a6d1965b35e302b2623cbd7e4e81e752ded
	# 	https://git.gnome.org/browse/nautilus/commit/?id=e96f73cf1589c023ade74e4aeb16a0c422790161
	eapply "${FILESDIR}"/${PN}-3.14.3-window-menus-unref-extension-created-action.patch
	eapply "${FILESDIR}"/${PN}-3.14.3-application-actions-use-valid-window-list.patch
	eapply "${FILESDIR}"/${PN}-3.17.3-ignore-no-desktop-if-not-first-launch.patch
	eapply "${FILESDIR}"/${PN}-3.18.5-thumbnails-avoid-crash-with-jp2-images.patch
	eapply "${FILESDIR}"/${PN}-3.19.91-files-view-hide-hidden-files-when-renamed.patch
	eapply "${FILESDIR}"/${PN}-3.20.2-do-not-reset-double-click-status-on-pointer-movement.patch

	# Remove -D*DEPRECATED flags. Don't leave this for eclass! (bug #448822)
	sed -e 's/DISABLE_DEPRECATED_CFLAGS=.*/DISABLE_DEPRECATED_CFLAGS=/' \
		-i configure || die "sed failed"

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-profiling \
		--disable-update-mimedb \
		$(use_enable debug) \
		$(use_enable exif libexif) \
		$(use_enable introspection) \
		$(use_enable packagekit) \
		$(use_enable sendto nst-extension) \
		$(use_enable tracker) \
		$(use_enable xmp)
}

src_test() {
	virtx emake check
}

src_install() {
	use previewer && readme.gentoo_create_doc
	gnome2_src_install
}

pkg_postinst() {
	gnome2_pkg_postinst

	if use previewer; then
		readme.gentoo_print_elog
	else
		elog "To preview media files, emerge nautilus with USE=previewer"
	fi
}
