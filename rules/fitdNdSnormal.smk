rule fitdNdSnormal:
    input:
        oesophagusdnds="results/oesophagus/dnds.csv",
        oesophagusdndsgenes="results/oesophagus/dnds_genes.csv",
        oesophagusdndsneutral="results/oesophagus/dnds_neutral.csv",
        oesophagusmetadata="data/oesophagus/donorinfo.csv",
        skindnds="results/skin/dnds.csv",
        skindndsgenes="results/skin/dnds_genes.csv",
        skinmetadata="data/skin/donorinfo.csv",
    output:
        oesophagusfitmissense = "results/dataforfigures/oesophagusfitmissense.csv",
        oesophagusfitnonsense = "results/dataforfigures/oesophagusfitnonsense.csv",
        skinfitmissense = "results/dataforfigures/skinfitmissense.csv",
        skinfitnonsense = "results/dataforfigures/skinfitnonsense.csv",
        oesophagusfitmissensepergene = "results/dataforfigures/oesophagusfitmissensepergene.csv",
        oesophagusfitnonsensepergene = "results/dataforfigures/oesophagusfitnonsensepergene.csv",
        skinfitmissensepergene = "results/dataforfigures/skinfitmissensepergene.csv",
        skinfitnonsensepergene = "results/dataforfigures/skinfitnonsensepergene.csv",
        oesophagusfitneutral = "results/dataforfigures/oesophagusneutral.csv"
    shell:
        """
        module unload R
        module load R/3.5.3
        module load julia
        export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:`R RHOME`/lib"
        julia julia/FitdNdS.jl \
            --oesophagusdndsdata {input.oesophagusdnds} \
            --oesophagusdndsdatagenes {input.oesophagusdndsgenes} \
            --oesophagusdndsneutral {input.oesophagusdndsneutral} \
            --oesophagusmetadata {input.oesophagusmetadata} \
            --skindndsdata {input.skindnds} \
            --skindndsdatagenes {input.skindndsgenes} \
            --skinmetadata {input.skinmetadata} \
            --oesophagusfitmissense {output.oesophagusfitmissense} \
            --oesophagusfitnonsense {output.oesophagusfitnonsense} \
            --skinfitmissense {output.skinfitmissense} \
            --skinfitnonsense {output.skinfitnonsense} \
            --oesophagusfitmissensepergene {output.oesophagusfitmissensepergene} \
            --oesophagusfitnonsensepergene {output.oesophagusfitnonsensepergene} \
            --skinfitmissensepergene {output.skinfitmissensepergene} \
            --skinfitnonsensepergene {output.skinfitnonsensepergene} \
            --oesophagusfitneutral {output.oesophagusfitneutral}
        """

rule formatresultsSSB:
    input: "results/oesophagus/SSBresults/{oes_sample2}_SSBdnds_results.xlsx"
    output: "results/oesophagus/SSBresults/{oes_sample2}_SSBdnds_results.csv"
    params:
        singlepatient=config["patient"],
        step=config["idndslimits"]["step"],
        minarea=config["idndslimits"]["minarea"],
        maxarea=config["idndslimits"]["maxarea"]
    shell:
        """
        Rscript R/formatSSB.R \
            --inputfile {input} \
            --outputfile {output} \
            --step {params.step} \
            --minarea {params.minarea} \
            --maxarea {params.maxarea}
        """
