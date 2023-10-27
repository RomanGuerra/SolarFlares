# Helios:

## Summarization, Mapping, Hotspot Discovery and Change Analysis of High-Intensity Solar Flare Events

### Solar Flare Intensity Estimation

**Batch Processing:** The data is divided into batches, with each batch representing a specific time period. The parameters for batch creation are specified, including batch size, overlap, and the start date. These are the following batches:
<ul>
    1+2+3+4,
    3+4+5+6,
    5+6+7+8,
    7+8+9+10,
    9+10+11+12,
    11+12+13+14,
    13+14+15+16,
    15+16+17+18,
    17+18+19+20,
    19+20+21+22,
    21+22+23+24,
</ul>

**Method 1 - Total Counts:** For each batch, the R code calculates the total intensity of solar flares by grouping the data based on the positions of solar flares (x and y coordinates) and summarizing the total counts. It creates heat maps to visualize the intensity for the current batch using both the group_by and aggregate functions. These heat maps are displayed for the first and last batch (i.e., batch 1 and batch 11).

![Batch1 Heat Map!](/plots/Method%201-1%20group.jpeg)

**Method 2 - Total Duration:** For each batch, the R code calculates the total duration of solar flares by grouping the data based on the positions of solar flares and summarizing the total duration. Again, it creates heat maps to visualize the intensity for the current batch using both the group_by and aggregate functions. These heat maps are displayed for the first and last batch (i.e., batch 1 and batch 11).

![Batch 11 Heat Map!](/plots/Method%202-2%20aggregate.jpeg "Heat Map")

In summary, the code divides the solar flare data into batches and estimates the intensity of solar flares within each batch using two methods: one based on total counts and the other based on total duration. Heat maps are generated to visualize the intensity for each batch. The code also shows heat maps for the first and last batch, making it easier to compare the results obtained using the two methods.

## Resources

[The Sun in Depth](http://solarcellcentral.com/sun_page.html)
[NASA spacecraft flies through sun explosion, and captures footage](http://solarcellcentral.com/sun_page.html)
[HESSI](https://en.wikipedia.org/wiki/Reuven_Ramaty_High_Energy_Solar_Spectroscopic_Imager)


<iframe width="560" height="315" src="https://www.youtube.com/embed/FF_e5eYgJ3Y?si=Kw5Sz5HzYaf_GapK" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>