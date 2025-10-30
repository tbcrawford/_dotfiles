#
# abbrs
#

set -q ABBRS_INITIALIZED; and return

# Core shortcuts
abbr -a -- - 'cd -'
abbr -a -- b bat
abbr -a -- c clear
abbr -a -- h history
abbr -a -- j just
abbr -a -- n npm
abbr -a -- y yarn

# Directory navigation
abbr -a -- ... '../..'
abbr -a -- .... '../../..'
abbr -a -- ..... '../../../..'
abbr -a -- ...... '../../../../..'
abbr -a -- ....... '../../../../../..'
abbr -a -- ........ '../../../../../../..'
abbr -a -- ......... '../../../../../../../..'
abbr -a -- .......... '../../../../../../../../..'

# Development tools
abbr -a -- glogin 'gcloud auth revoke; gcloud auth application-default revoke; gcloud auth login --update-adc'
abbr -a -- nukebin 'fd -t d bin --exec rm -rf'
abbr -a -- nukebuild 'fd -t d build --exec rm -rf'
abbr -a -- nukeds 'fd -t f -H .DS_Store --exec rm'
abbr -a -- tff 'terraform fmt -recursive'

# Fish config
abbr -a -- f. 'cd $__fish_config_dir'
abbr -a -- ff fish_fmt
abbr -a -- fl fish_lint
abbr -a -- fr fisher-reinstall
abbr -a -- fr. 'fisher-reinstall .'

# Date/time
abbr -a -- ds 'date +%Y-%m-%d'
abbr -a -- ts 'date +%Y-%m-%dT%H:%M:%SZ'
abbr -a -- yyyymmdd 'date +%Y%m%d'

# Applications
abbr -a -- c. 'code .'
abbr -a -- ch chezmoi
abbr -a -- csp cloud-sql-proxy
abbr -a -- dtf dependency-tree-diff
abbr -a -- mx mise
abbr -a -- nv nvim
abbr -a -- o. 'open .'
abbr -a -- pip pip3
abbr -a -- python python3
abbr -a -- sk skaffold
abbr -a -- tf terraform
abbr -a -- tfw terraformw

# Benchmark
abbr -a -- bm benchmark
abbr -a -- bmd 'benchmark --detailed'
abbr -a -- bmp 'benchmark --profile'

# Gradle
abbr -a -- gw './gradlew'
abbr -a -- gwb './gradlew build'
abbr -a -- gwbp './gradlew build publishToMavenLocal'
abbr -a -- gwc './gradlew check'
abbr -a -- gwd './gradlew detekt'
abbr -a -- gwf './gradlew fmt'
abbr -a -- gwfb './gradlew fmt build'
abbr -a -- gwfc './gradlew fmt check'
abbr -a -- gwft './gradlew fmt test'
abbr -a -- gwjb './gradlew fmt build -x test'
abbr -a -- gwl './gradlew lint'
abbr -a -- gwp './gradlew publishToMavenLocal'
abbr -a -- gws './gradlew --stop'
abbr -a -- gwt './gradlew test'

# Just
abbr -a -- jb 'just build'
abbr -a -- jbo 'just bounce'
abbr -a -- jde 'just did -e'
abbr -a -- jf 'just fmt'
abbr -a -- jp 'just pull'
abbr -a -- jr 'just run'
abbr -a -- js 'just stop'
abbr -a -- ju 'just up'
abbr -a -- jue 'just up -e'

# Kubernetes
abbr -a -- kc kubectx
abbr -a -- kn kubens
abbr -a -- kp 'kubectx figure-prod'
abbr -a -- kt 'kubectx figure-test'

# Zoxide shortcuts
abbr -a -c z atc auth0-tenant-config
abbr -a -c z atb terraform-auth0-tenant-base
abbr -a -c z pli platform-identity
abbr -a -c z pll platform-libraries
abbr -a -c z pcs platform-core-services
abbr -a -c z plf platform-frameworks
abbr -a -c z fgp figure-gradle-plugins

abbr -a -c z tatc ~/dev/tmp/auth0-tenant-config
abbr -a -c z tatb ~/dev/tmp/terraform-auth0-tenant-base
abbr -a -c z tpli ~/dev/tmp/platform-identity
abbr -a -c z tpll ~/dev/tmp/platform-libraries
abbr -a -c z tpcs ~/dev/tmp/platform-core-services
abbr -a -c z tplf ~/dev/tmp/platform-frameworks
abbr -a -c z tfgp ~/dev/tmp/figure-gradle-plugins

# no need to run over-and-over
set -g ABBRS_INITIALIZED true
