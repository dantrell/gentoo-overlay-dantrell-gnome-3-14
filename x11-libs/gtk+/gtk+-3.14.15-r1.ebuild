# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit autotools flag-o-matic gnome2 multilib virtualx multilib-minimal

DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="https://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="3/14" # From WebKit: http://trac.webkit.org/changeset/195811
KEYWORDS="*"

IUSE="aqua broadway cloudprint colord cups examples +introspection test vim-syntax wayland X xinerama"
REQUIRED_USE="
	|| ( aqua wayland X )
	xinerama? ( X )
"

# Upstream wants us to do their job:
# https://bugzilla.gnome.org/show_bug.cgi?id=768662#c1
RESTRICT="test"

# FIXME: introspection data is built against system installation of gtk+:3,
# bug #????
COMMON_DEPEND="
	>=dev-libs/atk-2.12[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.41.2:2[${MULTILIB_USEDEP}]
	media-libs/fontconfig[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.12[aqua?,glib,svg,X?,${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.30:2[introspection?,${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.36.7[introspection?,${MULTILIB_USEDEP}]
	x11-misc/shared-mime-info

	cloudprint? (
		>=net-libs/rest-0.7[${MULTILIB_USEDEP}]
		>=dev-libs/json-glib-1.0[${MULTILIB_USEDEP}] )
	colord? ( >=x11-misc/colord-0.1.9:0=[${MULTILIB_USEDEP}] )
	cups? ( >=net-print/cups-1.2[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.39:= )
	wayland? (
		>=dev-libs/wayland-1.5.91[${MULTILIB_USEDEP}]
		media-libs/mesa[wayland,${MULTILIB_USEDEP}]
		>=x11-libs/libxkbcommon-0.2[${MULTILIB_USEDEP}]
	)
	X? (
		>=app-accessibility/at-spi2-atk-2.5.3[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.3[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.3[${MULTILIB_USEDEP}]
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/libXcomposite[${MULTILIB_USEDEP}]
		x11-libs/libXdamage[${MULTILIB_USEDEP}]
		xinerama? ( x11-libs/libXinerama[${MULTILIB_USEDEP}] )
	)
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.1.2
	dev-libs/libxslt
	dev-libs/gobject-introspection-common
	>=dev-util/gdbus-codegen-2.38.2
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.18.3[${MULTILIB_USEDEP}]
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	X? ( x11-base/xorg-proto )
	test? (
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc )
"
# gtk+-3.2.2 breaks Alt key handling in <=x11-libs/vte-0.30.1:2.90
# gtk+-3.3.18 breaks scrolling in <=x11-libs/vte-0.31.0:2.90
RDEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-update-icon-cache-3
	!<gnome-base/gail-1000
	!<x11-libs/vte-0.31.0:2.90
	>=x11-themes/adwaita-icon-theme-3.14
"
# librsvg for svg icons (PDEPEND to avoid circular dep), bug #547710
PDEPEND="
	gnome-base/librsvg[${MULTILIB_USEDEP}]
	vim-syntax? ( app-vim/gtk-syntax )
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/gtk-query-immodules-3.0$(get_exeext)
)

strip_builddir() {
	local rule=$1
	shift
	local directory=$1
	shift
	sed -e "s/^\(${rule} =.*\)${directory}\(.*\)$/\1\2/" -i $@ \
		|| die "Could not strip director ${directory} from build."
}

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=738835
	eapply "${FILESDIR}"/${PN}-non-bash-support.patch

	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gtk+/commit/34e6e1a599375da5665f4829faedf4c640f031a6
	# 	https://gitlab.gnome.org/GNOME/gtk+/commit/2db7e3eaa8ed95adde5c2f8753cd3f63766ae67c
	# 	https://gitlab.gnome.org/GNOME/gtk+/commit/8753ef612940d5977bc8af2cca3ceb6cc669d1e4
	# 	https://gitlab.gnome.org/GNOME/gtk+/commit/631f6b536485829a0bd00532f5826ad302b4951b
	eapply "${FILESDIR}"/${PN}-3.14.15-avoid-g-set-object.patch
	eapply "${FILESDIR}"/${PN}-3.14.15-gtkplacessidebar-protect-for-checking-a-null-event.patch
	eapply "${FILESDIR}"/${PN}-3.15.2-render-shadows-for-half-tiled-windows.patch
	eapply "${FILESDIR}"/${PN}-3.21.3-configure-fix-detecting-cups-2-x.patch

	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gtk/commit/a3b402a9498787d2704f6ab228d3814683c946eb
	# 	https://gitlab.gnome.org/GNOME/gtk/commit/8c2b3930daa6d3886626907fbc79b812579b42d7
	# 	https://gitlab.gnome.org/GNOME/gtk/commit/5092febaf841939c7b3539ef447f43e1ce464037
	# 	https://gitlab.gnome.org/GNOME/gtk/commit/f8b24884b5cc6fbd582eae5e7aab3e234b3c4c26
	eapply "${FILESDIR}"/${PN}-3.17.7-gdk-add-touchpad-gesture-events-and-event-types.patch
	eapply "${FILESDIR}"/${PN}-3.17.7-gdk-add-gdk-touchpad-gesture-mask-to-gdkeventmask.patch
	eapply "${FILESDIR}"/${PN}-3.17.7-gdk-proxy-touchpad-events-through-the-client-side-window-hierarchy.patch
	eapply "${FILESDIR}"/${PN}-3.18.6-document-gdk-touchpad-gesture-mask.patch

	# -O3 and company cause random crashes in applications. Bug #133469
	replace-flags -O3 -O2
	strip-flags

	if ! use test ; then
		# don't waste time building tests
		strip_builddir SRC_SUBDIRS testsuite Makefile.{am,in}
		strip_builddir SRC_SUBDIRS tests Makefile.{am,in}
	fi

	if ! use examples; then
		# don't waste time building demos
		strip_builddir SRC_SUBDIRS demos Makefile.{am,in}
		strip_builddir SRC_SUBDIRS examples Makefile.{am,in}
	fi

	# call eapply_user (implicitly) before eautoreconf
	gnome2_src_prepare
	eautoreconf
}

multilib_src_configure() {
	# need libdir here to avoid a double slash in a path that libtool doesn't
	# grok so well during install (// between $EPREFIX and usr ...)
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		$(use_enable aqua quartz-backend) \
		$(use_enable broadway broadway-backend) \
		$(use_enable cloudprint) \
		$(use_enable colord) \
		$(use_enable cups cups auto) \
		$(multilib_native_use_enable introspection) \
		$(use_enable wayland wayland-backend) \
		$(use_enable X x11-backend) \
		$(use_enable X xcomposite) \
		$(use_enable X xdamage) \
		$(use_enable X xfixes) \
		$(use_enable X xkb) \
		$(use_enable X xrandr) \
		$(use_enable xinerama) \
		--disable-papi \
		--enable-man \
		--enable-gtk2-dependency \
		--with-xml-catalog="${EPREFIX}"/etc/xml/catalog \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		CUPS_CONFIG="${EPREFIX}/usr/bin/${CHOST}-cups-config"

	# work-around gtk-doc out-of-source brokedness
	if multilib_is_native_abi; then
		local d
		for d in gdk gtk libgail-util; do
			ln -s "${S}"/docs/reference/${d}/html docs/reference/${d}/html || die
		done
	fi
}

multilib_src_test() {
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/gtk" || die
	GSETTINGS_SCHEMA_DIR="${S}/gtk" virtx emake check
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	insinto /etc/gtk-3.0
	doins "${FILESDIR}"/settings.ini
	einstalldocs
}

pkg_preinst() {
	gnome2_pkg_preinst

	multilib_pkg_preinst() {
		# Make immodules.cache belongs to gtk+ alone
		local cache="usr/$(get_libdir)/gtk-3.0/3.0.0/immodules.cache"

		if [[ -e ${EROOT}${cache} ]]; then
			cp "${EROOT}"${cache} "${ED}"/${cache} || die
		else
			touch "${ED}"/${cache} || die
		fi
	}
	multilib_parallel_foreach_abi multilib_pkg_preinst
}

pkg_postinst() {
	gnome2_pkg_postinst

	multilib_pkg_postinst() {
		gnome2_query_immodules_gtk3 \
			|| die "Update immodules cache failed (for ${ABI})"
	}
	multilib_parallel_foreach_abi multilib_pkg_postinst

	if ! has_version "app-text/evince"; then
		elog "Please install app-text/evince for print preview functionality."
		elog "Alternatively, check \"gtk-print-preview-command\" documentation and"
		elog "add it to your settings.ini file."
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm

	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		multilib_pkg_postrm() {
			rm -f "${EROOT}"usr/$(get_libdir)/gtk-3.0/3.0.0/immodules.cache
		}
		multilib_foreach_abi multilib_pkg_postrm
	fi
}