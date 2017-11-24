# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_EAUTORECONF="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="GNOME framework for accessing online accounts"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeOnlineAccounts"

LICENSE="LGPL-2+"
SLOT="0/1"
KEYWORDS="*"

IUSE="debug gnome +introspection kerberos" # telepathy"

# pango used in goaeditablelabel
# libsoup used in goaoauthprovider
# goa kerberos provider is incompatible with app-crypt/heimdal, see
# https://bugzilla.gnome.org/show_bug.cgi?id=692250
# json-glib-0.16 needed for bug #485092
RDEPEND="
	>=dev-libs/glib-2.35:2
	>=app-crypt/libsecret-0.5
	>=dev-libs/json-glib-0.16
	dev-libs/libxml2:2
	>=net-libs/libsoup-2.42:2.4
	net-libs/rest:0.7
	net-libs/telepathy-glib
	>=net-libs/webkit-gtk-2.7.2:4
	>=x11-libs/gtk+-3.11.1:3
	x11-libs/pango

	introspection? ( >=dev-libs/gobject-introspection-0.6.2:= )
	kerberos? (
		app-crypt/gcr:0=[gtk]
		app-crypt/mit-krb5 )
"
#	telepathy? ( net-libs/telepathy-glib )
# goa-daemon can launch gnome-control-center
PDEPEND="gnome? ( >=gnome-base/gnome-control-center-3.2[gnome-online-accounts(+)] )"

DEPEND="${RDEPEND}
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.3
	>=dev-util/gdbus-codegen-2.30.0
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig

	dev-libs/gobject-introspection-common
	gnome-base/gnome-common
"
# eautoreconf needs gobject-introspection-common, gnome-common

PATCHES=(
	# From GNOME:
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=a8a818bfb525036a54c5197abe813b68a0c2c5e4
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=aac4049b8699d72147186ea4a6a283972ed4f8ce
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=b2051083c807dfcb3f6d176107e4035146affcca
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=de78b78bcd1b1f61fd04856d51e3f20caa6ff2ce
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=19565da9620a19fdce0335a23f7c70057eefebcc
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=cdfaf4621c359200d86bbf21823172d3048319b7
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=dbf2ccbccc8198920e564a14fc61671dc49174aa
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=2c6f5cb83eaae898973e9f3858228a1b48358e2a
	"${FILESDIR}"/${PN}-3.15.91-imap-smtp-dont-leak-the-strings.patch
	"${FILESDIR}"/${PN}-3.15.91-provider-dont-leak-the-gkeyfiles.patch
	"${FILESDIR}"/${PN}-3.15.91-pocket-add-missing-includes.patch
	"${FILESDIR}"/${PN}-3.15.91-oauth-oauth2-fix-the-webkit-includes.patch
	"${FILESDIR}"/${PN}-3.15.91-live-pocket-remove-redundant-includes.patch
	"${FILESDIR}"/${PN}-3.15.91-build-move-things-around-to-accommodate-the-new-web-extension.patch
	"${FILESDIR}"/${PN}-3.15.91-port-to-webkit-2.patch
	"${FILESDIR}"/${PN}-3.17.91-build-fix-parallel-install-failure.patch

	# From GNOME:
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=5dc30f43e6c721708a6d15fcfcd086a11d41bc2d
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=01882bde514aae12796c98e03818f8d30cbd13b9
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=53ce478c99d43f0cf8333e452edd228418112a2d
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=674330b0ccb816530ee6d31cea0f752e334f15d7
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=924689ce724cc0f1b893e1e0845c04f59eabd765
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=389ce7fad248998178778ca4a95dd8d09d4f38eb
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=236987b0dc06fb429e319bd29a2e9227b78b35e1
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=ee460859029833c7e607f668270d5946525e7d18
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=2893345fb5a81ae2de631ea82d4e9ff467c610f6
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=1f18560d1c151d69f2f72b63c436cfe2b86443a1
	# 	https://git.gnome.org/browse/gnome-online-accounts/commit/?id=5583ceb2d001655a492446238ac8074e31c7d2c9
	"${FILESDIR}"/${PN}-3.20.5-build-new-api-key-for-google.patch
	"${FILESDIR}"/${PN}-3.20.6-goa-identity-manager-get-identity-finish-should-return-a-new-ref.patch
	"${FILESDIR}"/${PN}-3.20.6-identity-fix-the-error-handling-when-signing-out-an-identity.patch
	"${FILESDIR}"/${PN}-3.20.6-identity-fix-ensure-credentials-for-accounts-leak.patch
	"${FILESDIR}"/${PN}-3.20.6-identity-dont-leak-the-invocation-when-handling-exchangesecretkeys.patch
	"${FILESDIR}"/${PN}-3.20.6-identity-dont-leak-operation-result-when-handling-exchangesecretkeys.patch
	"${FILESDIR}"/${PN}-3.20.6-identity-dont-leak-the-invocation-when-handling-signout.patch
	"${FILESDIR}"/${PN}-3.20.8-google-update-is-identity-node-to-match-the-web-ui.patch
	"${FILESDIR}"/${PN}-3.20.8-facebook-avoid-criticals-if-get-identity-sync-cant-parse-the-response.patch
	"${FILESDIR}"/${PN}-3.20.8-facebook-make-it-work-with-graph-api-2-3.patch
	"${FILESDIR}"/${PN}-3.20.8-facebook-update-readme.patch
)

# Due to sub-configure
QA_CONFIGURE_OPTIONS=".*"

src_configure() {
	# TODO: Give users a way to set the G/FB/Windows Live secrets
	# Twitter/Y! disabled per upstream recommendation, bug #497168
	# telepathy optional support is really badly done, bug #494456
	gnome2_src_configure \
		--disable-static \
		--disable-twitter \
		--disable-yahoo \
		--enable-documentation \
		--enable-exchange \
		--enable-facebook \
		--enable-flickr \
		--enable-imap-smtp \
		--enable-media-server \
		--enable-owncloud \
		--enable-pocket \
		--enable-telepathy \
		--enable-windows-live \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable kerberos) \
		$(use_enable introspection)
		#$(use_enable telepathy)
	# gudev & cheese from sub-configure is overriden
	# by top level configure, and disabled so leave it like that
}
