/**
 * Created by simon on 17.12.2017.
 */


var margin = {top: 20, right: 20, bottom: 30, left: 40},
    width = 900 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;

// set the ranges
var x = d3.scaleBand()
    .range([0, width])
    .padding(0.1);
var y = d3.scaleLinear()
    .range([height, 0]);

//https://bl.ocks.org/mbostock/3885705
//get slider and output
var slider = document.getElementById("sliderweekly");
slider.defaultValue = 1;
var outputweek = document.getElementById("valueweek");
outputweek.innerHTML = slider.value;

function bcweek() {
    outputweek.innerHTML = "Woche: "+ slider.value;
    //set text
//load the data dependent on selected week
d3.json("src/json/weekt"+slider.value+".json", function(error, data) {
    if (error) throw error;

    d3.select("#svgweekly").remove();

    var svgweekly = d3.select("#containersvgweekly").append("svg")
        .attr("id","svgweekly")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform",
            "translate(" + margin.left + "," + margin.top + ")");



    x.domain(data.map(function(d) { return d.party; }));
    y.domain([0, d3.max(data, function(d) { return d.percentage; })]);

    // append the rectangles for the bar chart
    svgweekly.selectAll(".bar")
        .data(data)
        .enter().append("rect")
        .attr("class", "bar")
        .attr("id",function(d) { return d.party; })
        .attr("x", function(d) { return x(d.party); })
        .attr("width", x.bandwidth())
        .attr("y", function(d) { return y(d.percentage); })
        .attr("height", function(d) { return height - y(d.percentage); })
        .on("mousemove", function(d){
            tooltip
                .style("left", d3.event.pageX - 50 + "px")
                .style("top", d3.event.pageY - 70 + "px")
                .style("display", "inline-block")
                .html("Anteil: "+Math.round(d.percentage*100)+"%" + "<br>" + "Anzahl: " + (d.freq)+ "<br>" + "Tweets Gesamt: " + (d.freqall));
    });
        //.on("mouseout", function(d){ tooltip.style("display", "none");}); !!buggy!!

    // add the x Axis
    svgweekly.append("g")
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(x));

    // add the y Axis
    svgweekly.append("g")
        .call(d3.axisLeft(y));

});

};

var slider2 = document.getElementById("sliderall");
slider2.defaultValue=1;
var outputall = document.getElementById("valueall");
outputall.innerHTML = slider.value;

function bcall() {
    outputall.innerHTML = "Woche: "+ slider2.value;


d3.json("src/json/weekn"+slider2.value+".json", function(error, data) {
    if (error) throw error;

    d3.select("#svgoverall").remove();

    var svgoverall = d3.select("#containersvgall").append("svg")
        .attr("id","svgoverall")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform",
            "translate(" + margin.left + "," + margin.top + ")");

    x.domain(data.map(function(d) { return d.party; }));
    y.domain([0, d3.max(data, function(d) { return d.percentage; })]);

    // append the rectangles for the bar chart
    svgoverall.selectAll(".bar")
        .data(data)
        .enter().append("rect")
        .attr("class", "bar")
        .attr("id",function(d) { return d.party; })
        .attr("x", function(d) { return x(d.party); })
        .attr("width", x.bandwidth())
        .attr("y", function(d) { return y(d.percentage); })
        .attr("height", function(d) { return height - y(d.percentage); })
        .on("mousemove", function(d){
            tooltip
                .style("left", d3.event.pageX - 50 + "px")
                .style("top", d3.event.pageY - 70 + "px")
                .style("display", "inline-block")
                .html("Anteil: "+Math.round(d.percentage*100)+"%" + "<br>" + "Anzahl: " + (d.freq)+ "<br>" + "Tweets Gesamt: " + (d.freqall));
        });

    // add the x Axis
    svgoverall.append("g")
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(x));

    // add the y Axis
    svgoverall.append("g")
        .call(d3.axisLeft(y));

});};