if [[ ${EBUILD_PHASE} == "setup" ]] ; then
	CURRENT_PROFILE=$(eselect --brief profile show)
	if [ -z "$(echo ${CURRENT_PROFILE} | grep unity-gentoo)" ]; then
		die "Invalid profile detected, please select a 'unity-gentoo' profile for your architecture shown in 'eselect profile list'"
	else
		PROFILE_RELEASE=$(echo "${CURRENT_PROFILE}" | sed -n 's/.*:\(.*\)\/.*/\1/p')
	fi

	if [ "$(eval echo \${UNITY_DEVELOPMENT_${PROFILE_RELEASE}})" != "yes" ]; then
		die "Oops! A development profile has been detected. Set 'UNITY_DEVELOPMENT_${PROFILE_RELEASE}=yes' in make.conf if you really know how broken this profile could be"
	fi
fi

pre_src_prepare() {
	## Mimic the function of 'epatch_user' and /etc/portage/patches/ so we can custom patch packages we don't need to maintain ##
	#    Most below taken from eutils.eclass #
	local REPO_ROOT="$(/usr/bin/portageq get_repo_path / unity-gentoo)"
	local EPATCH_SOURCE check base=${REPO_ROOT}/profiles/${PROFILE_RELEASE}/patches
	local applied="${T}/epatch_user.log"

	for check in ${CATEGORY}/{${P}-${PR},${P},${PN}}{,:${SLOT}}; do
		EPATCH_SOURCE=${base}/${CTARGET}/${check}
		[[ -r ${EPATCH_SOURCE} ]] || EPATCH_SOURCE=${base}/${CHOST}/${check}
		[[ -r ${EPATCH_SOURCE} ]] || EPATCH_SOURCE=${base}/${check}
		if [[ -d ${EPATCH_SOURCE} ]] ; then
			EPATCH_SOURCE=${EPATCH_SOURCE} \
			EPATCH_SUFFIX="patch" \
			EPATCH_FORCE="yes" \
			EPATCH_MULTI_MSG="Applying user patches from ${EPATCH_SOURCE} ..." \
			epatch
			echo "${EPATCH_SOURCE}" > "${applied}"
			return 0
		fi
	done
}