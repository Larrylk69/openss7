# vim: ft=config sw=4 noet nocin nosi com=b\:#,b\:dnl,b\:***,b\:@%\:@ fo+=tcqlorn
# =============================================================================
# BEGINNING OF SEPARATE COPYRIGHT MATERIAL
# =============================================================================
# 
# @(#) $RCSfile: rpm.m4,v $ $Name: OpenSS7-0_9_2 $($Revision: 0.9.2.84 $) $Date: 2008-10-31 11:58:28 $
#
# -----------------------------------------------------------------------------
#
# Copyright (c) 2001-2008  OpenSS7 Corporation <http://www.openss7.com/>
# Copyright (c) 1997-2001  Brian F. G. Bidulock <bidulock@openss7.org>
#
# All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation; version 3 of the License.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>, or write to
# the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# -----------------------------------------------------------------------------
#
# U.S. GOVERNMENT RESTRICTED RIGHTS.  If you are licensing this Software on
# behalf of the U.S. Government ("Government"), the following provisions apply
# to you.  If the Software is supplied by the Department of Defense ("DoD"), it
# is classified as "Commercial Computer Software" under paragraph 252.227-7014
# of the DoD Supplement to the Federal Acquisition Regulations ("DFARS") (or any
# successor regulations) and the Government is acquiring only the license rights
# granted herein (the license rights customarily provided to non-Government
# users).  If the Software is supplied to any unit or agency of the Government
# other than DoD, it is classified as "Restricted Computer Software" and the
# Government's rights in the Software are defined in paragraph 52.227-19 of the
# Federal Acquisition Regulations ("FAR") (or any successor regulations) or, in
# the cases of NASA, in paragraph 18.52.227-86 of the NASA Supplement to the FAR
# (or any successor regulations).
#
# -----------------------------------------------------------------------------
#
# Commercial licensing and support of this software is available from OpenSS7
# Corporation at a fee.  See http://www.openss7.com/
#
# -----------------------------------------------------------------------------
#
# Last Modified $Date: 2008-10-31 11:58:28 $ by $Author: brian $
#
# =============================================================================

# =============================================================================
# _RPM_SPEC
# -----------------------------------------------------------------------------
# Common things that need to be done in setting up an RPM spec file from an
# RPM.spec.in file.  This also includes stuff for converting the LSM file.
# -----------------------------------------------------------------------------
AC_DEFUN([_RPM_SPEC], [dnl
    _RPM_SPEC_OPTIONS
    _RPM_SPEC_SETUP
    _RPM_SPEC_OUTPUT
])# _RPM_SPEC
# =============================================================================

# =============================================================================
# _RPM_SPEC_OPTIONS
# -----------------------------------------------------------------------------
AC_DEFUN([_RPM_SPEC_OPTIONS], [dnl
    _RPM_OPTIONS_RPM_EPOCH
    _RPM_OPTIONS_RPM_RELEASE
])# _RPM_SPEC_OPTIONS
# =============================================================================

# =============================================================================
# _RPM_OPTIONS_RPM_EPOCH
# -----------------------------------------------------------------------------
AC_DEFUN([_RPM_OPTIONS_RPM_EPOCH], [dnl
    AC_MSG_CHECKING([for rpm epoch])
    AC_ARG_WITH([rpm-epoch],
	AS_HELP_STRING([--with-rpm-epoch=EPOCH],
	    [specify the EPOCH for the package file.  @<:@default=auto@:>@]),
	[with_rpm_epoch="$withval"],
	[if test -r .rpmepoch; then d= ; else d="$srcdir/" ; fi
	 if test -r ${d}.rpmepoch
	 then with_rpm_epoch="`cat ${d}.rpmepoch`"
	 else with_rpm_epoch=0
	 fi])
    AC_MSG_RESULT([${with_rpm_epoch:-0}])
    PACKAGE_RPMEPOCH="${with_rpm_epoch:-0}"
    AC_SUBST([PACKAGE_RPMEPOCH])dnl
    AC_DEFINE_UNQUOTED([PACKAGE_RPMEPOCH], [$PACKAGE_RPMEPOCH], [The RPM Epoch.
			This defaults to 0.])
])# _RPM_OPTIONS_RPM_EPOCH
# =============================================================================

# =============================================================================
# _RPM_OPTIONS_RPM_RELEASE
# -----------------------------------------------------------------------------
AC_DEFUN([_RPM_OPTIONS_RPM_RELEASE], [dnl
    AC_MSG_CHECKING([for rpm release])
    AC_ARG_WITH([rpm-release],
	AS_HELP_STRING([--with-rpm-release=RELEASE],
	    [specify the RELEASE for the package files.  @<:@default=auto@:>@]),
	[with_rpm_release="$withval"],
	[if test -r .rpmrelease ; then d= ; else d="$srcdir/" ; fi
	 if test -r ${d}.rpmrelease
	 then with_rpm_release="`cat ${d}.rpmrelease`"
	 else with_rpm_release=1
	 fi])
    AC_MSG_RESULT([${with_rpm_release:-1}])
    PACKAGE_RPMRELEASE="${with_rpm_release:-1}"
    AC_SUBST([PACKAGE_RPMRELEASE])dnl
    AC_DEFINE_UNQUOTED([PACKAGE_RPMRELEASE], ["$PACKAGE_RPMRELEASE"], [The RPM
			Release. This defaults to 1.])
])# _RPM_OPTIONS_RPM_RELEASE
# =============================================================================

# =============================================================================
# _RPM_SPEC_SETUP
# -----------------------------------------------------------------------------
AC_DEFUN([_RPM_SPEC_SETUP], [dnl
    _RPM_SPEC_SETUP_DIST
    _RPM_SPEC_SETUP_TOOLS
    _RPM_SPEC_SETUP_MODULES
    _RPM_SPEC_SETUP_TOPDIR
    _RPM_SPEC_SETUP_OPTIONS
    _RPM_SPEC_SETUP_BUILD
])# _RPM_SPEC_SETUP
# =============================================================================

# =============================================================================
# _RPM_SPEC_SETUP_DIST
# -----------------------------------------------------------------------------
AC_DEFUN([_RPM_SPEC_SETUP_DIST], [dnl
    AC_REQUIRE([_DISTRO])
    AC_ARG_WITH([rpm-extra],
	AS_HELP_STRING([--with-rpm-extra=EXTRA],
	    [override or disable the EXTRA release string for built RPMS. @<:@default=auto@:>@]),
	[with_rpm_extra="$withval"],
	[if test -r .rpmextra ; then d= ; else d="$srcdir/" ; fi
	 if test -r ${d}.rpmextra
	 then with_rpm_extra="`cat ${d}.rpmextra`"
	 else with_rpm_extra=""
	 fi])
    AC_CACHE_CHECK([for rpm distribution extra release string], [rpm_cv_dist_extra], [dnl
	case :${with_rpm_extra:-auto} in
	    (:no)
		rpm_cv_dist_extra=
		;;
	    (:auto)
		case "$dist_cv_host_flavor" in
		    (centos)
			case $dist_cv_host_release in
			    (3|3.?)	rpm_cv_dist_extra=".centos3"	;;
			    (4|4.?)	rpm_cv_dist_extra=".centos4"	;;
			    (5|5.?)	rpm_cv_dist_extra=".centos5"	;;
			    (*)		rpm_cv_dist_extra=".centos${dist_cv_host_release}" ;;
			esac
			;;
		    (lineox)
			case $dist_cv_host_release in
			    (3|3.?)	rpm_cv_dist_extra=".lel3"	;;
			    (4|4.?)	rpm_cv_dist_extra=".lel4"	;;
			    (5|5.?)	rpm_cv_dist_extra=".lel5"	;;
			    (*)		rpm_cv_dist_extra=".lel${dist_cv_host_release}" ;;
			esac
			;;
		    (whitebox)
			case $dist_cv_host_release in
			    (3|3.?)	rpm_cv_dist_extra=".WB3"	;;
			    (4|4.?)	rpm_cv_dist_extra=".WB4"	;;
			    (5|5.?)	rpm_cv_dist_extra=".WB5"	;;
			    (*)		rpm_cv_dist_extra=".WB${dist_cv_host_release}" ;;
			esac
			;;
		    (fedora)
			case $dist_cv_host_release in
			    (1)		rpm_cv_dist_extra=".FC1"	;;
			    (2)		rpm_cv_dist_extra=".FC2"	;;
			    (3)		rpm_cv_dist_extra=".FC3"	;;
			    (4)		rpm_cv_dist_extra=".FC4"	;;
			    (5)		rpm_cv_dist_extra=".FC5"	;;
			    (6)		rpm_cv_dist_extra=".FC6"	;;
			    (7)		rpm_cv_dist_extra=".fc7"	;;
			    (8)		rpm_cv_dist_extra=".fc8"	;;
			    (9)		rpm_cv_dist_extra=".fc9"	;;
			    (*)		rpm_cv_dist_extra=".fc${dist_cv_host_release}" ;;
			esac
			;;
		    (redhat)
			case $dist_cv_host_release in
			    (7.0)	rpm_cv_dist_extra=".7.0"	;;
			    (7.1)	rpm_cv_dist_extra=".7.1"	;;
			    (7.2)	rpm_cv_dist_extra=".7.2"	;;
			    (7.3)	rpm_cv_dist_extra=".7.3"	;;
			    (8.0)	rpm_cv_dist_extra=".8.0"	;;
			    (9)		rpm_cv_dist_extra=".9"		;;
			    (2|2.?)	rpm_cv_dist_extra=".EL"		;;
			    (3|3.?)	rpm_cv_dist_extra=".E3"		;;
			    (4|4.?)	rpm_cv_dist_extra=".EL4"	;;
			    (5|5.?)	rpm_cv_dist_extra=".EL5"	;;
			    (*)		rpm_cv_dist_extra2=".EL${dist_cv_host_release}" ;;
			esac
			;;
		    (mandrake)
			rpm_tmp=`echo "$dist_cv_host_release" | sed -e 's|\.||g'`
			rpm_cv_dist_extra=".${rpm_tmp}mdk"
			;;
		    (suse)
			case $dist_cv_host_release in
			    (6.2|7.[[0-3]]|8.[[0-3]]|9.[[0-3]])
					rpm_cv_dist_extra=".${dist_cv_host_release:-SuSE}" ;;
			    (8|9|10)	rpm_cv_dist_extra=".${dist_cv_host_release:-SLES}" ;;
			    (*)		rpm_cv_dist_extra=".${dist_cv_host_release:-SuSE}" ;;
			esac
			;;
		    (debian)
			rpm_cv_dist_extra=".deb${dist_cv_host_release}"
			;;
		    (ubuntu)
			rpm_cv_dist_extra=".ubuntu${dist_cv_host_release}"
			;;
		esac
		;;
	    (*)
		rpm_cv_dist_extra="$with_rpm_extra"
		;;
	esac
    ])
    AC_CACHE_CHECK([for rpm distribution extra release string2], [rpm_cv_dist_extra2], [dnl
	case :${with_rpm_extra:-auto} in
	    (:no)
		rpm_cv_dist_extra2=
		;;
	    (:auto)
		case "$dist_cv_host_flavor" in
		    (centos)
			case $dist_cv_host_release in
			    (3|3.?)	rpm_cv_dist_extra2=".EL3"	;;
			    (4|4.?)	rpm_cv_dist_extra2=".EL4"	;;
			    (5|5.?)	rpm_cv_dist_extra2=".EL5"	;;
			    (*)		rpm_cv_dist_extra2=".COS${dist_cv_host_release}" ;;
			esac
			;;
		    (lineox)
			case $dist_cv_host_release in
			    (3|3.?)	rpm_cv_dist_extra2=".EL3"	;;
			    (4|4.?)	rpm_cv_dist_extra2=".EL4"	;;
			    (5|5.?)	rpm_cv_dist_extra2=".EL5"	;;
			    (*)		rpm_cv_dist_extra2=".LEL${dist_cv_host_release}" ;;
			esac
			;;
		    (whitebox)
			case $dist_cv_host_release in
			    (3|3.?)	rpm_cv_dist_extra2=".EL3"	;;
			    (4|4.?)	rpm_cv_dist_extra2=".EL4"	;;
			    (5|5.?)	rpm_cv_dist_extra2=".EL5"	;;
			    (*)		rpm_cv_dist_extra2=".WB${dist_cv_host_release}" ;;
			esac
			;;
		    (fedora)
			case $dist_cv_host_release in
			    (1)		rpm_cv_dist_extra2=".FC1"	;;
			    (2)		rpm_cv_dist_extra2=".FC2"	;;
			    (3)		rpm_cv_dist_extra2=".FC3"	;;
			    (4)		rpm_cv_dist_extra2=".FC4"	;;
			    (5)		rpm_cv_dist_extra2=".FC5"	;;
			    (6)		rpm_cv_dist_extra2=".FC6"	;;
			    (7)		rpm_cv_dist_extra2=".fc7"	;;
			    (8)		rpm_cv_dist_extra2=".fc8"	;;
			    (9)		rpm_cv_dist_extra2=".fc9"	;;
			    (*)		rpm_cv_dist_extra2=".fc${dist_cv_host_release}" ;;
			esac
			;;
		    (redhat)
			case $dist_cv_host_release in
			    (7.[[0-3]])	rpm_cv_dist_extra2=".7.x"	;;
			    (8.0)	rpm_cv_dist_extra2=".8"		;;
			    (9)		rpm_cv_dist_extra2=".9"		;;
			    (2|2.?)	rpm_cv_dist_extra2=".EL"	;;
			    (3|3.?)	rpm_cv_dist_extra2=".EL3"	;;
			    (4|4.?)	rpm_cv_dist_extra2=".EL4"	;;
			    (5|5.?)	rpm_cv_dist_extra2=".EL5"	;;
			    (*)		rpm_cv_dist_extra2=".RH${dist_cv_host_release}" ;;
			esac
			;;
		    (mandrake)
			rpm_tmp=`echo "$dist_cv_host_release" | sed -e 's|\.||g'`
			rpm_cv_dist_extra2=".${rpm_tmp}mdk"
			;;
		    (suse)
			case $dist_cv_host_release in
			    (6.2|7.[[0-3]]|8.[[0-3]]|9.[[0-3]])
					rpm_cv_dist_extra2=".${dist_cv_host_release:-SuSE}" ;;
			    (8|9|10)	rpm_cv_dist_extra2=".${dist_cv_host_release:-SLES}" ;;
			    (*)		rpm_cv_dist_extra2=".${dist_cv_host_release:-SuSE}" ;;
			esac
			;;
		    (debian)
			rpm_cv_dist_extra2=".deb${dist_cv_host_release}"
			;;
		    (ubuntu)
			rpm_cv_dist_extra2=".ubuntu${dist_cv_host_release}"
			;;
		esac
		;;
	    (*)
		rpm_cv_dist_extra2="$with_rpm_extra"
		;;
	esac
    ])
    AC_CACHE_CHECK([for rpm distribution default topdir], [rpm_cv_dist_topdir], [dnl
	case "$dist_cv_host_flavor" in
	    (centos)	rpm_cv_dist_topdir='/usr/src/redhat' ;;
	    (lineox)	rpm_cv_dist_topdir='/usr/src/redhat' ;;
	    (whitebox)	rpm_cv_dist_topdir='/usr/src/redhat' ;;
	    (fedora)	rpm_cv_dist_topdir='/usr/src/redhat' ;;
	    (mandrake)	rpm_cv_dist_topdir='/usr/src/RPM'    ;;
	    (redhat)	rpm_cv_dist_topdir='/usr/src/redhat' ;;
	    (suse)	rpm_cv_dist_topdir='/usr/src/SuSE'   ;;
	    (debian)	rpm_cv_dist_topdir='/usr/src/rpm'    ;;
	    (ubuntu)	rpm_cv_dist_topdir='/usr/src/rpm'    ;;
	    (*)		rpm_cv_dist_topdir="$ac_abs_top_buiddir" ;;
	esac
    ])
    AC_CACHE_CHECK([for rpm distribution subdirectory], [rpm_cv_dist_subdir], [dnl
	case "$dist_cv_host_flavor" in
	    (centos|lineox|whitebox|fedora|mandrake|mandriva|redhat|suse)
		rpm_cv_dist_subdir="$dist_cv_host_flavor/$dist_cv_host_release/$dist_cv_host_cpu" ;;
	    (debian|ubuntu|*)
		rpm_cv_dist_subdir="$dist_cv_host_flavor/$dist_cv_host_codename/$dist_cv_host_cpu" ;;
	esac
	if test -n "$rpm_cv_dist_subdir"; then
	    rpm_cv_dist_subdir=`echo "$rpm_cv_dist_subdir" | sed -e 'y,ABCDEFGHIJKLMNOPQRSTUVWXYZ,abcdefghijklmnopqrstuvwxyz,'`
	fi
    ])
    PACKAGE_RPMSUBDIR="${rpm_cv_dist_subdir}"
    AC_SUBST([PACKAGE_RPMSUBDIR])dnl
    AC_DEFINE_UNQUOTED([PACKAGE_RPMSUBDIR], ["$PACKAGE_RPMSUBDIR"], [The RPM Distribution
	subdirectory.  This defaults to automatic detection.])
    PACKAGE_RPMDIST="${dist_cv_host_distrib:-Unknown Linux} ${dist_cv_host_release:-Unknown}${dist_cv_host_codename:+ ($dist_cv_host_codename)}"
    AC_SUBST([PACKAGE_RPMDIST])dnl
    AC_DEFINE_UNQUOTED([PACKAGE_RPMDIST], ["$PACKAGE_RPMDIST"], [The RPM Distribution.  This
	defaults to automatic detection.])
    PACKAGE_RPMEXTRA="${rpm_cv_dist_extra}"
    PACKAGE_RPMEXTRA2="${rpm_cv_dist_extra2}"
    AC_SUBST([PACKAGE_RPMEXTRA])dnl
    AC_SUBST([PACKAGE_RPMEXTRA2])dnl
    AC_DEFINE_UNQUOTED([PACKAGE_RPMEXTRA], ["$PACKAGE_RPMEXTRA"], [The RPM Extra Release string.
	This defaults to automatic detection.])
    AC_DEFINE_UNQUOTED([PACKAGE_RPMEXTRA2], ["$PACKAGE_RPMEXTRA2"], [The RPM Extra Release string.
	This defaults to automatic detection.])
])# _RPM_SPEC_SETUP_DIST
# =============================================================================

# =============================================================================
# _RPM_SPEC_SETUP_TOOLS
# -----------------------------------------------------------------------------
# The RPM spec file is set up for either building kernel dependent packages
# or kernel independent packages.  This option specifies whether kernel
# independent (user space) packages are to be built.  This option can also
# be used for general kernel independent builds.
# -----------------------------------------------------------------------------
AC_DEFUN([_RPM_SPEC_SETUP_TOOLS], [dnl
    AC_MSG_CHECKING([for rpm build/install of user packages])
    AC_ARG_ENABLE([tools],
	AS_HELP_STRING([--enable-tools],
	    [build and install user packages.  @<:@default=yes@:>@]),
	[enable_tools="$enableval"],
	[enable_tools='yes'])
    AC_MSG_RESULT([${enable_tools:-yes}])
    AM_CONDITIONAL([RPM_BUILD_USER], [test ":${enable_tools:-yes}" = :yes])dnl
])# _RPM_SPEC_SETUP_TOOLS
# =============================================================================

# =============================================================================
# _RPM_SPEC_SETUP_MODULES
# -----------------------------------------------------------------------------
# The RPM spec file is set up for either building kernel dependent packages
# or kernel independent packages.  This option specifies whether kernel
# dependent (kernel module) packages are to be built.  This option can also
# be used for general kernel dependent builds.
# -----------------------------------------------------------------------------
AC_DEFUN([_RPM_SPEC_SETUP_MODULES], [dnl
    AC_MSG_CHECKING([for rpm build/install of kernel packages])
    AC_ARG_ENABLE([modules],
	AS_HELP_STRING([--enable-modules],
	    [build and install kernel packages.  @<:@default=yes@:>@]),
	[enable_modules="$enableval"],
	[enable_modules='yes'])
    AC_MSG_RESULT([${enable_modules:-yes}])
    AM_CONDITIONAL([RPM_BUILD_KERNEL], [test ":${enable_modules:-yes}" = :yes])dnl
])# _RPM_SPEC_SETUP_MODULES
# =============================================================================

# =============================================================================
# _RPM_SPEC_SETUP_TOPDIR
# -----------------------------------------------------------------------------
# This is setting up the RPM topdir and the SOURCES BUILD RPMS SRPMS and SPECS
# directories.  We override rpm settings to acheive several objectives:  We do
# not want to move the tarballs (sources) from the tarball distribution
# directory, but use them in place.  Therefore we want to override the SOURCES
# and SPECS directories.  Because topdir is on an NFS mount when we build, but
# we want to speed builds as much as possible, we override the BUILD directory
# to be in our autoconf build directory which should be on a local filesystem.
# The remaining two, RPMS and SRPMS are left in the distribution directory under
# topdir.  The am/rpm.am makefile fragment will override rpm macros with these
# values.  Note that the names stay nicely out of the way of autoconf directory
# names, but all nicely end in dir so we will define them in the same way.
# (Yes, autoconf defines `builddir' even though it is always `.'.
# -----------------------------------------------------------------------------
AC_DEFUN([_RPM_SPEC_SETUP_TOPDIR], [dnl
    AC_REQUIRE([_OPENSS7_OPTIONS_PKG_DISTDIR])
    # when building in place the default is simply rpms whereas when releasing
    # to another directory, the default is based on the repo subdirectory name
    if test :$PACKAGE_DISTDIR = :`pwd` ; then
	rpm_tmp='$(PACKAGE_DISTDIR)/rpms'
    else
	rpm_tmp='$(PACKAGE_DISTDIR)/rpms/'"${rpm_cv_dist_subdir}"
    fi
    AC_ARG_WITH([rpm-topdir],
	AS_HELP_STRING([--with-rpm-topdir=DIR],
	    [specify the rpm top directory.  @<:@default=PKG-DISTDIR/rpms@:>@]),
	[with_rpm_topdir="$withval"],
	[with_rpm_topdir="$rpm_tmp"])
    AC_CACHE_CHECK([for rpm top build directory], [rpm_cv_topdir], [dnl
	case ":${with_rpm_topdir:-default}" in
	    (:no | :NO)
		rpm_cv_topdir="$rpm_tmp"
		;;
	    (:yes | :YES | :default | :DEFAULT)
		rpm_cv_topdir="$rpm_cv_dist_topdir"
		;;
	    (*)
		rpm_cv_topdir="$with_rpm_topdir"
		;;
	esac
    ])
    topdir="$rpm_cv_topdir"
    AC_SUBST([topdir])dnl
    # set defaults for the rest
    AC_CACHE_CHECK([for rpm SOURCES directory], [rpm_cv_sourcedir], [dnl
	if test :$PACKAGE_DISTDIR = :`pwd` ; then
	    rpm_cv_sourcedir='$(PACKAGE_DISTDIR)'
	else
	    rpm_cv_sourcedir='$(PACKAGE_DISTDIR)/tarballs'
	fi
    ])
    sourcedir="$rpm_cv_sourcedir"
    AC_SUBST([sourcedir])dnl
    AC_CACHE_CHECK([for rpm BUILD directory], [rpm_cv_builddir], [dnl
	# rpmbuilddir needs to be absolute: always build in the top build
	# directory on the local machine
	rpm_cv_builddir=`pwd`/BUILD
    ])
    rpmbuilddir="$rpm_cv_builddir"
    AC_SUBST([rpmbuilddir])dnl
    AC_CACHE_CHECK([for rpm RPMS directory], [rpm_cv_rpmdir], [dnl
	rpm_cv_rpmdir='$(topdir)/RPMS'
    ])
    rpmdir="$rpm_cv_rpmdir"
    AC_SUBST([rpmdir])dnl
    AC_CACHE_CHECK([for rpm SRPMS directory], [rpm_cv_srcrpmdir], [dnl
	rpm_cv_srcrpmdir='$(PACKAGE_DISTDIR)/rpms/SRPMS'
    ])
    srcrpmdir="$rpm_cv_srcrpmdir"
    AC_SUBST([srcrpmdir])dnl
    AC_CACHE_CHECK([for rpm SPECS directory], [rpm_cv_specdir], [dnl
	rpm_cv_specdir='$(PACKAGE_DISTDIR)/rpms/SPECS'
    ])
    specdir="$rpm_cv_specdir"
    AC_SUBST([specdir])dnl
])# _RPM_SPEC_SETUP_TOPDIR
# =============================================================================

# =============================================================================
# _RPM_SPEC_SETUP_OPTIONS
# -----------------------------------------------------------------------------
# Older rpms (particularly those used by SuSE) rpms are too stupid to handle
# --with and --without rpmpopt syntax, so convert to the equivalent --define
# syntax Also, I don't know that even rpm 4.2 handles --with xxx=yyy
# properly, so we use defines.
AC_DEFUN([_RPM_SPEC_SETUP_OPTIONS], [dnl
    args="$ac_configure_args"
    args=`echo " $args " | sed -r -e 's, (.)?--(en|dis)able-maintainer-mode(.)? , ,g;s,^ *,,;s, *$,,'`
    args=`echo " $args " | sed -r -e 's, (.)?--(en|dis)able-dependency-tracking(.)? , ,g;s,^ *,,;s, *$,,'`
    args=`echo " $args " | sed -r -e 's, (.)?--(en|dis)able-modules(.)? , ,g;s,^ *,,;s, *$,,'`
    args=`echo " $args " | sed -r -e 's, (.)?--(en|dis)able-tools(.)? , ,g;s,^ *,,;s, *$,,'`
    args=`echo " $args " | sed -r -e 's, (.)?--(en|dis)able-arch(.)? , ,g;s,^ *,,;s, *$,,'`
    args=`echo " $args " | sed -r -e 's, (.)?--(en|dis)able-indep(.)? , ,g;s,^ *,,;s, *$,,'`
    args=`echo " $args " | sed -r -e 's, (.)?--(en|dis)able-devel(.)? , ,g;s,^ *,,;s, *$,,'`
    args=`echo " $args " | sed -r -e 's, (.)?--with(out)?-lis(=[[^[:space:]]]*)?(.)? , ,g;s,^ *,,;s, *$,,'`
    args=`echo " $args " | sed -r -e 's, (.)?--with(out)?-lfs(=[[^[:space:]]]*)?(.)? , ,g;s,^ *,,;s, *$,,'`
    args=`echo " $args " | sed -r -e 's, (.)?--with(out)?-k-release(=[[^[:space:]]]*)?(.)? , ,g;s,^ *,,;s, *$,,'`
    for arg_part in $args ; do
	if (echo "$arg_part" | grep "^'" >/dev/null 2>&1) ; then
	    if test -n "$arg" ; then
		eval "arg=$arg"
		AC_MSG_CHECKING([for rpm argument '$arg'])
		if (echo $arg | egrep '^(--enable|--disable|--with|--without)' >/dev/null 2>&1) ; then
		    nam=`echo $arg | sed -e 's|[[= ]].*$||;s|--enable|--with|;s|--disable|--without|;s|-|_|g;s|^__|_|'`
		    arg="--define \"${nam} ${arg}\""
		    PACKAGE_RPMOPTIONS="${PACKAGE_RPMOPTIONS}${PACKAGE_RPMOPTIONS:+ }$arg"
		    AC_MSG_RESULT([yes])
		else
		    :
		    AC_MSG_RESULT([no])
		fi
	    fi
	    arg="$arg_part"
	else
	    arg="${arg}${arg:+ }${arg_part}"
	fi
    done
    if test -n "$arg" ; then
	eval "arg=$arg"
	AC_MSG_CHECKING([for rpm argument '$arg'])
	if (echo $arg | egrep '^(--enable|--disable|--with|--without)' >/dev/null 2>&1) ; then
	    nam=`echo $arg | sed -e 's|[[= ]].*$||;s|--enable|--with|;s|--disable|--without|;s|-|_|g;s|^__|_|'`
	    arg="--define \"${nam} ${arg}\""
	    PACKAGE_RPMOPTIONS="${PACKAGE_RPMOPTIONS}${PACKAGE_RPMOPTIONS:+ }$arg"
	    AC_MSG_RESULT([yes])
	else
	    :
	    AC_MSG_RESULT([no])
	fi
    fi
    AC_SUBST([PACKAGE_RPMOPTIONS])dnl
])# _RPM_SPEC_SETUP_OPTIONS
# =============================================================================

# =============================================================================
# _RPM_SPEC_SETUP_BUILD
# -----------------------------------------------------------------------------
AC_DEFUN([_RPM_SPEC_SETUP_BUILD], [dnl
dnl
dnl These environment variables are precious.
dnl
dnl AC_ARG_VAR([RPM_SOURCE_DIR], [RPM source directory.])
dnl AC_ARG_VAR([RPM_BUILD_DIR], [RPM build directory.])
dnl AC_ARG_VAR([RPM_OPT_FLAGS], [RPM optimization cflags.])
dnl AC_ARG_VAR([RPM_ARCH], [RPM architecture.])
dnl AC_ARG_VAR([RPM_OS], [RPM operating system.])
dnl AC_ARG_VAR([RPM_DOC_DIR], [RPM documentation directory.])
dnl AC_ARG_VAR([RPM_PACKAGE_NAME], [RPM package name.])
dnl AC_ARG_VAR([RPM_PACKAGE_VERSION], [RPM package version.])
dnl AC_ARG_VAR([RPM_PACKAGE_RELEASE], [RPM package release.])
dnl AC_ARG_VAR([RPM_BUILD_ROOT], [RPM installation root.])
dnl AC_ARG_VAR([PKG_CONFIG_PATH], [RPM configuration path.])
dnl
dnl These commands are needed to perform RPM package builds.
dnl
    AC_ARG_ENABLE([rpms],
	AS_HELP_STRING([--disable-rpms],
	    [disable building of rpms.  @<:@default=auto@:>@]),
	[enable_rpms="$enableval"],
	[enable_rpms=yes])
    AC_ARG_ENABLE([srpms],
	AS_HELP_STRING([--disable-srpms],
	    [disable building of srpms.  @<:@default=auto@:>@]),
	[enable_srpms="$enableval"],
	[enable_srpms=yes])
    AC_ARG_VAR([RPM],
	       [Rpm command. @<:@default=rpm@:>@])
    AC_PATH_PROG([RPM], [rpm], [],
		 [$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin])
    if test ":${RPM:-no}" = :no; then
	if test ":$enable_rpms" = :yes; then
	    case "$target_vendor" in
		(centos|lineox|whitebox|fedora|mandrake|mandriva|redhat|suse)
		    AC_MSG_WARN([Could not find rpm program in PATH.]) ;;
		(*) enable_rpms=no ;;
	    esac
	fi
	ac_cv_path_RPM="${am_missing3_run}rpm"
	RPM="${am_missing3_run}rpm"
    fi
    AC_ARG_VAR([RPMBUILD],
	       [Rpm build command. @<:@default=rpmbuild@:>@])
    AC_PATH_PROG([RPMBUILD], [rpmbuild], [],
		 [$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin])
    if test ":${RPMBUILD:-no}" = :no; then
	if test ":$enable_rpms" = :yes; then
	    ac_cv_path_RPMBUILD="$RPM"
	    RPMBUILD="$RPM"
	else
	    ac_cv_path_RPMBUILD="${am_missing3_run}rpmbuild";
	    RPMBUILD="${am_missing3_run}rpmbuild";
	    enable_srpms=no;
	fi
    fi
dnl
dnl I add a test for the existence of /var/lib/rpm because debian has rpm commands
dnl but no rpm database and therefore cannot build rpm packages.  But it can build
dnl src.rpms.
dnl
    if test ! -d /var/lib/rpm; then
	enable_rpms=no
    fi
    AC_CACHE_CHECK([for rpm build rpms], [rpm_cv_rpms], [dnl
	rpm_cv_rpms=${enable_rpms:-no}
    ])
    AC_CACHE_CHECK([for rpm build srpms], [rpm_cv_srpms], [dnl
	rpm_cv_srpms=${enable_srpms:-no}
    ])
    AM_CONDITIONAL([BUILD_RPMS], [test ":$enable_rpms" = :yes])dnl
    AM_CONDITIONAL([BUILD_SRPMS], [test ":$enable_srpms" = :yes])dnl
dnl
dnl These commands are needed to create RPM (e.g. YUM) repositories.
dnl
    AC_ARG_ENABLE([repo-yum],
	AS_HELP_STRING([--disable-repo-yum],
	    [disable yum repo construction.  @<:@default=auto@:>@]),
	[enable_repo_yum="$enableval"],
	[enable_repo_yum=yes])
    AC_ARG_VAR([CREATEREPO],
	       [Create repomd repository command. @<:@default=createrepo@:>@])
    AC_PATH_PROG([CREATEREPO], [createrepo], [],
		 [$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin])
    if test ":${CREATEREPO:-no}" = :no; then
	if test ":$rpm_cv_rpms" = :yes; then
	    AC_MSG_WARN([Could not find createrepo program in PATH.])
	fi
	enable_repo_yum=no
	ac_cv_path_CREATEREPO="${am_missing3_run}createrepo"
	CREATEREPO="${am_missing3_run}createrepo"
    fi
    AC_CACHE_CHECK([for rpm yum repo construction], [rpm_cv_repo_yum], [dnl
	rpm_cv_repo_yum=${enable_repo_yum:-no}
    ])
    AM_CONDITIONAL([BUILD_REPO_YUM], [test ":$rpm_cv_repo_yum" = :yes])dnl
    repodir="$topdir/repodata"
    AC_SUBST([repodir])dnl

dnl
dnl These commands can be used to create YaST repositories.
dnl
    AC_ARG_ENABLE([repo-yast],
	AS_HELP_STRING([--disable-repo-yast],
	    [disable yast repo construction.  @<:@default=auto@:>@]),
	[enable_repo_yast="$enableval"],
	[enable_repo_yast=yes])
    AC_ARG_VAR([CREATE_PACKAGE_DESCR],
	       [Create YaST package descriptions command.  @<:@default=create_package_descr@:>@])
    AC_PATH_PROG([CREATE_PACKAGE_DESCR], [create_package_descr], [],
		 [$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin])
    if test ":${CREATE_PACKAGE_DESCR:-no}" = :no; then
	if test ":$rpm_cv_rpms" = :yes; then
	    if test ":$target_vendor" = :suse; then
		AC_MSG_WARN([Could not find create_package_descr program in PATH.])
	    fi
	fi
	enable_repo_yast=no
	ac_cv_path_CREATE_PACKAGE_DESCR="${am_missing3_run}create_package_descr"
	CREATE_PACKAGE_DESCR="${am_missing3_run}create_package_descr"
    fi
    AC_CACHE_CHECK([for rpm yast repo construction], [rpm_cv_repo_yast], [dnl
	rpm_cv_repo_yast=${enable_repo_yast:-no}
    ])
    AM_CONDITIONAL([BUILD_REPO_YAST], [test ":$rpm_cv_repo_yast" = :yes])dnl
    yastdir="$topdir"
    AC_SUBST([yastdir])dnl
])# _RPM_SPEC_SETUP_BUILD
# =============================================================================

# =============================================================================
# _RPM_SPEC_OUTPUT
# -----------------------------------------------------------------------------
AC_DEFUN([_RPM_SPEC_OUTPUT], [dnl
    AC_CONFIG_FILES([scripts/speccommon])
    speccommon="scripts/speccommon"
    AC_SUBST_FILE([speccommon])
    AC_CONFIG_FILES(m4_ifdef([AC_PACKAGE_TARNAME],[AC_PACKAGE_TARNAME]).spec)
    AC_CONFIG_FILES(m4_ifdef([AC_PACKAGE_TARNAME],[AC_PACKAGE_TARNAME]).lsm)
    if test ":${enable_public:-yes}" != :yes ; then
	PACKAGE="${PACKAGE_TARNAME}"
	VERSION="bin-${PACKAGE_VERSION}.${PACKAGE_RELEASE}${PACKAGE_PATCHLEVEL}"
    else
	PACKAGE="${PACKAGE_TARNAME}"
	VERSION="${PACKAGE_VERSION}.${PACKAGE_RELEASE}${PACKAGE_PATCHLEVEL}"
    fi
])# _RPM_SPEC_OUTPUT
# =============================================================================

# =============================================================================
# _RPM_
# -----------------------------------------------------------------------------
AC_DEFUN([_RPM_], [dnl
])# _RPM_
# =============================================================================

# =============================================================================
#
# $Log: rpm.m4,v $
# Revision 0.9.2.84  2008-10-31 11:58:28  brian
# - more distros
#
# Revision 0.9.2.83  2008-10-27 12:23:34  brian
# - suppress warning on each iteration and cache results
#
# Revision 0.9.2.82  2008-09-28 06:50:23  brian
# - change order of spec files
#
# Revision 0.9.2.81  2008-09-28 05:52:34  brian
# - add subsitution of common spec file
#
# Revision 0.9.2.80  2008/09/22 17:57:38  brian
# - substitute rpm subdirectory
#
# Revision 0.9.2.79  2008/09/21 14:09:33  brian
# - correction
#
# Revision 0.9.2.78  2008-09-21 07:10:07  brian
# - environment passed to rpm and dpkg cannot be precious
#
# Revision 0.9.2.77  2008/09/20 23:50:05  brian
# - change fallback from rpmbuild to rpm
#
# Revision 0.9.2.76  2008-09-20 23:06:08  brian
# - corrections
#
# Revision 0.9.2.75  2008-09-20 12:15:24  brian
# - typo
#
# Revision 0.9.2.74  2008-09-20 11:17:14  brian
# - build system updates
#
# Revision 0.9.2.73  2008-09-19 06:19:38  brian
# - typo
#
# Revision 0.9.2.72  2008-09-19 05:18:45  brian
# - separate repo directory by architecture
#
# Revision 0.9.2.71  2008/09/18 09:11:01  brian
# - add more rpm stuff for debian
#
# Revision 0.9.2.70  2008-09-17 05:53:03  brian
# - place source in tarballs directory for remote build
#
# Revision 0.9.2.69  2008-09-16 09:47:47  brian
# - updates to rpmspec files
#
# Revision 0.9.2.68  2008-09-12 06:12:09  brian
# - correction
#
# Revision 0.9.2.67  2008-09-12 05:23:20  brian
# - add repo subdirectories
#
# Revision 0.9.2.66  2008/07/23 19:14:41  brian
# - indicates support to CentOS 5.2
#
# Revision 0.9.2.65  2008-04-28 09:41:03  brian
# - updated headers for release
#
# Revision 0.9.2.64  2008/04/27 22:28:39  brian
# - fix conditional error
#
# Revision 0.9.2.63  2007/10/17 20:00:28  brian
# - slightly different path checks
#
# Revision 0.9.2.62  2007/08/12 19:05:31  brian
# - rearrange and update headers
#
# =============================================================================
# 
# Copyright (c) 2001-2008  OpenSS7 Corporation <http://www.openss7.com/>
# Copyright (c) 1997-2000  Brian F. G. Bidulock <bidulock@openss7.org>
# 
# =============================================================================
# ENDING OF SEPARATE COPYRIGHT MATERIAL
# =============================================================================
# vim: ft=config sw=4 noet nocin nosi com=b\:#,b\:dnl,b\:***,b\:@%\:@ fo+=tcqlorn