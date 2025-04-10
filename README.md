# Test GitHub Actions Caching

In this repo I've created a demo where `docker/bake-action` uses `cache-from` and `cache-to` for three separate caching mechanisms, all at the registry level:

1. Branch caching which takes the following form:

    cache-branch-${{ steps.safe_ref_name.outputs.safe_ref_name }}

2. Shared cache as "most recent build" cache:

    cache-shared

3. Default branch cache that only updates on merge. This conditional is triggered via:

    github.ref_name == github.event.repository.default_branch

and results in a tag that looks like:

    ${{ github.event.repository.default_branch }} # i.e. "main"

The relevant code in the worflow is here:

    - name: Make REF_NAME safe for docker tagging
      run: echo "safe_ref_name=${GITHUB_REF_NAME//\//-}" >> $GITHUB_OUTPUT
      id: safe_ref_name

    - name: Build and push
      uses: docker/bake-action@v6.5.0
      with:
        pull: true
        push: ${{ github.ref_name == github.event.repository.default_branch }}
        files: core/noble/docker-bake.hcl
        source: .
        set: |
          *.cache-from=type=registry,ref=ghcr.io/djbender/test-ga-caching:cache-branch-${{ steps.safe_ref_name.outputs.safe_ref_name }}
          *.cache-from=type=registry,ref=ghcr.io/djbender/test-ga-caching:cache-shared
          ${{ format('*.cache-from=type=registry,ref=ghcr.io/djbender/test-ga-caching:{0}', github.event.repository.default_branch) }}

          *.cache-to=type=registry,ref=ghcr.io/djbender/test-ga-caching:cache-branch-${{ steps.safe_ref_name.outputs.safe_ref_name }},compression=zstd
          *.cache-to=type=registry,ref=ghcr.io/djbender/test-ga-caching:cache-shared,compression=zstd
          ${{ github.ref_name == github.event.repository.default_branch && format('*.cache-to=type=registry,ref=ghcr.io/djbender/test-ga-caching:{0}', github.event.repository.default_branch) || '' }}

          *.platform=linux/arm64
