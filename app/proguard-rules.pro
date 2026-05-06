# This is a configuration file for ProGuard.
# http://proguard.sourceforge.net/index.html#manual/usage.html
-dontusemixedcaseclassnames
-verbose
# Optimization is turned off by default. Dex does not like code run
# through the ProGuard optimize and preverify steps (and performs some
# of this optimization on its own).
-dontoptimize
-dontpreverify
# Note that if you want to enable optimization, you cannot just
# include optimization flags in this configuration file; instead you
# will need to specify "-dontshrink" explicitly to disable shrinking.
# Shrinking is enabled by default.
-keep public class javax.**
-keep public class java.**
