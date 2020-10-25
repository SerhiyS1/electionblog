<font size="6"><b>Blog Post 10/24/2020: How will COVID-19 Affect the 2020 Election?</b></font>

The COVID-19 pandemic has been world-changing and has become likely the most salient issue on the populace's mind.  It has affected the economy, public health, and has reinvented a new normal in the United States.  As this issue will be on many voters' minds on election day in less than two weeks, I found it appropriate to investigate in this week's blog.  In Part 1, I will analyze how the novel coronavirus affected all 50 states in terms of the percent of all deaths due to COVID-19, and then will focus more specifically on swing states.  In Part 2, I investigate the polling averages in these swing states and look into how the coronavirus may have affected them.

<font size="4"><b>Part 1: How have different states experienced the pandemic? </b></font>

In Part 1, I analyzed how the coronavirus has affected the 50 states.  I used a dataset on COVID-19 data from 2/1/2020 - 10/10/2020 by county from the CDC, grouped and summarized it by state, and created a new variable: percentage of all deaths due to COVID-19.  Figure 1, below, demonstrates a visualization of each state's percentage of all deaths due to the coronavirus.  I used this variable because it may be a good indicator of the severity of the outbreaks in a state.

![](/percentdeaths.png)  

The line of best fit in this model had a y-intercept of 38.94% and a slope of -1.380.  This slope means that for every 1% increase in white people in Texas, the Democratic two-party vote share decreased by 1.38%.  It also means that every 1% decrease in white people is associated with a 1.38% increase in the Democratic two-party vote share.  The multiple R-squared on this model was 0.1669, indicating that 16.69% of the data fits the regression model.  

![](/covidswing.png)

Thus, this model is not very responsible for the variation in the Texan Democratic two-party vote share.  However, the data visualization provides interesting insights into the status of the 2020 race.  It is visible that as Texas gets more non-white, the higher the Democratic two-party vote-share gets.  If Joe Biden wants to end the Republicans 10 election cycle streak in Texas, his campaign must focus on appealing to and motivating turnout among people of color.

<font size="4"><b> Part 2: How are swing states' polling numbers at the height of COVID-19? </b></font>

In Part 2, I analyzed how the change in the women makeup of Texas from the previous presidential election affects the Texas Democratic two-party vote share.  I used the same methodology as in Part 1 except my independent variable was the change in the women makeup of Texas. 

![](/swingstatepolls.png) 

The line of best fit in this model had a y-intercept of 41.39% and a slope of -8.416.  This slope means that for every 1% increase in women in Texas, the Democratic two-party vote share decreased by 8.416%.  The multiple R-squared on this model was 0.07366, indicating that this model is not very responsible for the variation in the Texan Democratic two-party vote share.  A more improved version of this model would use the change of <b> women voters </b> in Texas as the independent variable, not the change in the amount of women.  I hope to gather this data and recreate this model next week.  Since the men/women divide in Texas is based on biology, not politics, the demographic change percentage is nearly 0% for this category. 
  


<font size="4"><b>Conclusions and Sources</b></font>

For the final portion of this week's analysis, I analyzed the change between Texas' demographics in 2016 and 2018 to see how it would affect the Democratic
two-party vote share in 2020. 

<b>This week's prediction: still a Biden win. </b>

Thank you for reading! You can follow my election modeling journey by checking this blog each Saturday through December.

To complete this blog post, I utilized _____ from the Gov 1347: Election Analytics course website.


[1] https://projects.fivethirtyeight.com/2020-election-forecast/

