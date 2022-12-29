# 🪄 ALPHAFOLD2 RESULTS

**[Main results page is here: ../README.md#-alphafold2-results](../README.md#-alphafold2-results)**

**🕵️‍♂️ Citation :**
- Jumper, J. et al. Highly accurate protein structure prediction with AlphaFold. Nature 596, 583–589 (2021).
- Evans, R. et al. Protein complex prediction with AlphaFold-Multimer. http://biorxiv.org/lookup/doi/10.1101/2021.10.04.463034 (2021) doi:10.1101/2021.10.04.463034.

**🔗 Acces link:** [https://alphafold.ebi.ac.uk/](https://alphafold.ebi.ac.uk/)

## 💻 Method

For doing this modele, we used ColabFold accessible here: [https://github.com/sokrypton/ColabFold](https://github.com/sokrypton/ColabFold). The problem was we are poor and we couldn't use GoogleColab Pro (*sad noises*). Why ? Our protein was to big to be modelled in one shot (not enough RAM). So, we decided to take our sequence and divide it into two parts:
- First 1,000 amino acid **= first part**.
- Last 1,000 amino acid **= second part**.

After, we used MODELLER to re-assemble the two part into one [**(cf. MODELLER part for the general method)**](../MODELLER/README.md).

## 📊 Results
**INFERNO COLOUR PALETTE:**
*Low confidence - ![../inferno.svg](../inferno.svg) - High confidence*

![first_half.png](first_half.png)

**First part modelled by ALPHAFOLD 2.** Colour palette is inferno.

![second_half.png](second_half.png)

**Second part modelled by ALPHAFOLD 2.** Colour palette is inferno.

![BEST_MODEL.png](BEST_MODEL.png)

**Full model, after completion with MODELLER.** Colour indicate secondary structure.

There's some loops and some helix that AlphaFold is not confident about. But overall, the model is quite good (even better than our MODELLER model). The only problem is the time and the memory complexity of the model, which led us to use MODELLER instead of using only AlphaFold.

**[Main results page is here: ../README.md#-alphafold2-results](../README.md#-alphafold2-results)**
