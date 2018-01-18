Steps for doing a release:

1. Review open issues and PRs to see if any can easily be fixed, closed, or
   merged.
2. Review `Changes` for completeness and correctness.
3. Run `dzil release` and follow the prompts.
4. Verify the release on [MetaCPAN](https://metacpan.org/pod/WebService::MinFraud).
   It may take a few minutes for it to notice the new release. You should also
   receive an email from the PAUSE indexer.
