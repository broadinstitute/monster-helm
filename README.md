# monster-helm
Helm charts for the Monster team in DSP

## Using Charts
Charts hosted by this repo are made available via GitHub pages.
Add the repo using:
```bash
helm repo add monster https://broadinstitute.github.io/monster-helm
```
Then install charts using:
```bash
helm install monster/<chart-name>
```

### Available Charts
* `argo-controller`: Namespace-scoped deployment of the Argo workflow controller,
                     with persistence enabled.
* `argo-server`: Cluster-wide deployment of the Argo workflow server + UI, with
                 HTTPS ingress
* `argo-templates`: Collection of generic Argo workflow templates, for use across
                    our ingest pipelines
* `gcp-managed-cert`: Tiny chart to render a GKE managed TLS certificate
* `pure-ftpd`: Deployment of an FTP server, backed by a persistent volume

## Developing Charts
We don't (yet) have a robust process for validating chart changes. For now,
the best we can automatically do is validate that rendering a chart succeeds,
and that the result is valid YAML. This validation runs during PRs. It can
also be run manually using the `hack/validate-charts` script.

In order for validation to run, at least one values YAML must be defined within
the `example-values` directory of the chart. The content of these YAMLs should
be valid inputs for the chart, like would be passed to `helm install`.

Finally, just because a chart produces valid YAML doesn't mean it's a
semantically-valid k8s definition. Feel free to manually `helm install`
charts into a dev cluster to test local changes before pushing a PR.
The `helm-operator` can also be configured to pull charts from a git branch,
if you're testing in a cluster where it's available.

Once you're satisfied with the changes you've made, make sure to update
(at least) the value of `version` in the chart's `Chart.yaml`.

## Publishing Charts
Charts are published automatically by GitHub actions on updates to master.
Note that this process is pretty dumb, and will fail if you update a chart
in any way without bumping its version in `Chart.yaml`.

If you want to publish a branch for pre-PR testing, you can do so by adding
your branch name to the list in the [GH Action](.github/workflows/release-new-charts.yaml).
You'll still need to bump the version in `Chart.yaml` on every update.
