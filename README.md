# monster-helm
Helm charts for the Monster team in DSP

## Using charts
Charts hosted by this repo are made available via GitHub pages.
Add the repo using:
```bash
helm repo add monster https://broadinstitute.github.io/monster-helm
```
Then install charts using:
```bash
helm install monster/<chart-name>
```

## Developing charts
We don't (yet) have a strict process for testing chart changes. Feel
free to manually create a new namespace in our dev GKE cluster, and
run `helm install` from the root of a chart directory to test local
changes.

Once you're satisfied with the changes you've made, make sure to update
(at least) the value of `version` in the chart's `Chart.yaml`.

## Publishing charts
We don't (yet) have an automated process for publishing charts. To publish
manually, first create a [GitHub token](https://github.com/settings/tokens)
with access to all repo scopes. Update your `~/.bash_profile` to export the
value of the token as `CH_TOKEN`, for example by adding:
```bash
export CH_TOKEN=$(cat <path-to-file-containing-token>)
```

Once you have a token, you can use the [publish script](./hack/publish-charts)
to push new chart versions.
```bash
./hack/publish-charts <chart1> <chart2> ...
```
