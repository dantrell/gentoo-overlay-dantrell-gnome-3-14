# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome2

DESCRIPTION="A GNOME application for managing encryption keys"
HOMEPAGE="https://wiki.gnome.org/Apps/Seahorse"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
KEYWORDS="*"

IUSE="debug ldap zeroconf"

COMMON_DEPEND="
	>=app-crypt/gcr-3.11.91:0=
	>=dev-libs/glib-2.10:2
	>=x11-libs/gtk+-3.4:3
	>=app-crypt/libsecret-0.16
	>=net-libs/libsoup-2.33.92:2.4
	x11-misc/shared-mime-info

	net-misc/openssh
	>=app-crypt/gpgme-1
	>=app-crypt/gnupg-2.0.12

	ldap? ( net-nds/openldap:= )
	zeroconf? ( >=net-dns/avahi-0.6:=[dbus] )
"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.35
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"
# Need seahorse-plugins git snapshot
RDEPEND="${COMMON_DEPEND}
	!<app-crypt/seahorse-plugins-2.91.0_pre20110114
"

src_prepare() {
	# Do not mess with CFLAGS with USE="debug"
	sed -e '/CFLAGS="$CFLAGS -g/d' \
		-e '/CFLAGS="$CFLAGS -O0/d' \
		-i configure.ac configure || die "sed 1 failed"

	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/seahorse/-/commit/48362cd12c80b941b2371ceaab3decb74811ed7a
	# 	https://gitlab.gnome.org/GNOME/seahorse/-/commit/dfabc8de30e87fd7b6dc6d12f34fa29858caed95
	# 	https://gitlab.gnome.org/GNOME/seahorse/-/commit/31a9a6ffc10f9737e70d7f0051ff590ff284ad07
	eapply "${FILESDIR}"/${PN}-3.15.90-pgp-force-use-of-the-first-gnupg-found-by-configure-ac.patch
	eapply "${FILESDIR}"/${PN}-3.17.4-avoid-binding-seahorse-to-the-build-time-version-of-gpg.patch
	eapply "${FILESDIR}"/${PN}-9999-accept-gnupg-2-2-x-as-supported-version.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# bindir is needed due to bad macro expansion in desktop file, bug #508610
	gnome2_src_configure \
		--bindir=/usr/bin \
		--enable-pgp \
		--enable-ssh \
		--enable-pkcs11 \
		--enable-hkp \
		$(use_enable debug) \
		$(use_enable ldap) \
		$(use_enable zeroconf sharing) \
		VALAC=$(type -P true)
}
