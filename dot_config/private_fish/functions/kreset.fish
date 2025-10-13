#
# Reset Kubernetes contexts for figure-test and figure-prod using gcloud and kubectx (idempotent)
#
# Safely recreates Kubernetes contexts for Figure development and production environments.
# Removes existing contexts, fetches fresh credentials from gcloud, and renames contexts
# to standardized names. Idempotent operation that can be run multiple times safely.
#
# @return 0 on successful context reset, non-zero on gcloud/kubectl errors
# @example kreset
#
function kreset -d "Reset Kubernetes contexts for figure-test and figure-prod using gcloud and kubectx (idempotent)"
    # Remove old contexts if they exist
    if kubectl config get-contexts -o name | string match -q -- figure-test
        kubectx -d figure-test >/dev/null 2>&1
    end

    if kubectl config get-contexts -o name | string match -q -- figure-prod
        kubectx -d figure-prod >/dev/null 2>&1
    end

    # Recreate figure-test context
    gcloud container clusters get-credentials tf-test \
        --zone us-east1-b \
        --project figure-development \
        --dns-endpoint

    # Rename only if needed and source exists
    if not kubectl config get-contexts -o name | string match -q -- figure-test
        if kubectl config get-contexts -o name | string match -q -- gke_figure-development_us-east1-b_tf-test
            kubectl config rename-context \
                gke_figure-development_us-east1-b_tf-test \
                figure-test
        end
    end

    # Recreate figure-prod context
    gcloud container clusters get-credentials figure-production-cluster \
        --zone us-east1-b \
        --project figure-production \
        --dns-endpoint

    # Rename only if needed and source exists
    if not kubectl config get-contexts -o name | string match -q -- figure-prod
        if kubectl config get-contexts -o name | string match -q -- gke_figure-production_us-east1-b_figure-production-cluster
            kubectl config rename-context \
                gke_figure-production_us-east1-b_figure-production-cluster \
                figure-prod
        end
    end
end
