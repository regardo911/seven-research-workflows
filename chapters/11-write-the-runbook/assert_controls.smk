# Chapter 11, transcribed verbatim. Paste it into your Snakefile and make your
# final outputs depend on .controls_ok.
#
# Read the awk carefully before you trust it: it tests presence only. The rubric
# row it promotes, and verify.sh, both assert count > 0. A control that reaches
# the final table at zero passes this gate and fails the script. The README next
# to this file has the one-character fix and the reason it is not applied here.
rule assert_controls:
    input:
        table = f"{OUT}/final_table.tsv"
    output:
        f"{OUT}/.controls_ok"
    params:
        controls = config["design"]["controls"]
    shell:
        """
        missing=""
        for c in {params.controls}; do
          awk -F'\\t' -v c="$c" '$1 == c {{found = 1}} END {{exit !found}}' {input.table} \
            || missing="$missing $c"
        done
        if [[ -n "$missing" ]]; then
          echo "MISSING CONTROLS:$missing" >&2
          exit 1
        fi
        touch {output}
        """
