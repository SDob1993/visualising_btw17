/**
 * Created by simon on 12.12.2017.
 */

//select the canvas
var canvas = d3.select("#network"),
    widthnet = canvas.attr("width"),
    heightnet = canvas.attr("height"),
    ctx = canvas.node().getContext("2d"),
    r = 3,
    simulation = d3.forceSimulation()       //use d3 methods to set the layout
        .force("x", d3.forceX(widthnet/2))
        .force("y", d3.forceY(heightnet/2))
        .force("collide", d3.forceCollide(r+5))
        .force("charge", d3.forceManyBody()
            .strength(-25))
        .force("link", d3.forceLink()
            .id(function (d) { return d.name; }));

var nameuser = "",
    partyuser = "",
    freqposts = "";

var tooltip = d3.select("body").append("div").attr("class", "toolTip");


d3.json("src/json/nwnew.json", function (err, graph) { //load the data
    if (err) throw err;
    simulation.nodes(graph.nodes);
    simulation.force("link")
        .links(graph.links);
    simulation.on("tick", update);
    canvas
        .call(d3.drag()     //drag https://bl.ocks.org/mbostock/ad70335eeef6d167bc36fd3c04378048
            .container(canvas.node())
            .subject(dragsubject)
            .on("start", dragstarted)
            .on("drag", dragged)
            .on("end", dragended));


    function update() { //clears and draws new per tick
        ctx.clearRect(0, 0, widthnet, heightnet);
        ctx.beginPath();
        ctx.globalAlpha = 0.1;
        ctx.strokeStyle = "#999";
        graph.links.forEach(drawLink);
        ctx.stroke();
        ctx.globalAlpha = 1.0;
        graph.nodes.forEach(drawNode);
        ctx.font="30px Georgia";
        ctx.fillText("Name: "+nameuser,100,100);
        ctx.fillText("Partei: "+partyuser,100,150);
        ctx.fillText("Anzahl Tweets: "+freqposts,100,200);


    }
    function dragsubject() {
        return simulation.find(d3.event.x, d3.event.y);
    }
});
function dragstarted() {
    if (!d3.event.active) simulation.alphaTarget(0.3).restart();
    d3.event.subject.fx = d3.event.subject.x;
    d3.event.subject.fy = d3.event.subject.y;
    nameuser = d3.event.subject.name;
    partyuser = d3.event.subject.party;
    freqposts = d3.event.subject.freq;




}
function dragged() {
    d3.event.subject.fx = d3.event.x;
    d3.event.subject.fy = d3.event.y;
}
function dragended() {
    if (!d3.event.active) simulation.alphaTarget(0);
    d3.event.subject.fx = null;
    d3.event.subject.fy = null;

}


function drawNode(d) { //draws nodes and gives them color dependent on their party
    ctx.beginPath();
    colorcsu = "#4169e1";
    colorcdu = "#000";
    colorfdp = "#ffed00";
    colorgruene = "#1fa12d";
    colorafd = "#009ee0";
    colorspd = "#e2001a";
    colorlinke = "#9932CD";
    switch (d.party){
        case "GRUENE": colorparty=colorgruene;
            break;
        case "CSU": colorparty=colorcsu;
            break;
        case "CDU": colorparty=colorcdu;
            break;
        case "FDP": colorparty=colorfdp;
            break;
        case "AfD": colorparty=colorafd;
            break;
        case "SPD": colorparty=colorspd;
            break;
        case "DIE LINKE": colorparty=colorlinke;
            break;
    }
    ctx.fillStyle = colorparty;
    ctx.moveTo(d.x, d.y);
    ctx.arc(d.x, d.y, d.pagerank*1500, 0, Math.PI*2);
    ctx.fill();
}
function drawLink(l) {
    ctx.moveTo(l.source.x, l.source.y);
    ctx.lineTo(l.target.x, l.target.y);

}