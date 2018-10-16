$(document).on('turbolinks:load', function() {
  createDashChart(
    gon.lastDayOfMonth,
    gon.monthName,
    gon.requests,
    gon.errorRates,
    gon.responseTimes
  );
});

// function for showing chart on dashboard of a project
function createDashChart(days, month, requests, errors, responses) {
    var DAYS = [];
    for (i = 0; i < days; i++) {
      DAYS[i] = (i+1 + month);
    }

    var chartData =[];
    for (i = 0; i < DAYS.length; i++) {
      chartData.push( {
        "day": DAYS[i],
        "responseTime": responses[i],
        "errorRate": errors[i],
        "requests": requests[i]
      });
    }

    var maxResponses = Math.ceil(Math.max.apply(null, responses) / 200) * 200;
    var maxErrorRate = Math.ceil(Math.max.apply(null, errors) / 20) * 20;

    AmCharts.makeChart("chartdiv",
      {
        "type": "serial",
        "categoryField": "day",
        "colors": [
          "#008990",
          "#FF546A",
          "#B0DE09"
        ],
        "startDuration": 0,
        "fontFamily": "Sanuk",
        "fontSize": 15,
        "categoryAxis": {
          "startOnAxis": true,
          "autoGridCount": true,
          "showLastLabel": true,
          "labelFrequency": 7
        },
        "trendLines": [],
        "graphs": [
          {
            "showBalloon": false,
            "bullet": "none",
            "id": "responseGraph",
            "title": "Antwortzeit in ms",
            "valueField": "responseTime",
            "lineThickness": 1
          },
          {
            "showBalloon": false,
            "bullet": "none",
            "id": "errorsGraph",
            "title": "Fehlerrate in %",
            "valueAxis": "errorAxis",
            "valueField": "errorRate",
            "lineThickness": 1
          }
        ],
        "guides": [
          {
            "label": maxResponses/2 + " ms",
            "inside": false,
            "lineAlpha": 0.2,
            "value": maxResponses/2,
            "toValue": maxResponses/2,
            "valueAxis": "responseAxis",
            "tickLength": 0
          },
          {
            "label": maxResponses + " ms",
            "inside": false,
            "lineAlpha": 0.2,
            "value": maxResponses,
            "toValue": maxResponses,
            "valueAxis": "responseAxis",
            "tickLength": 0
          },
          {
            "label": maxErrorRate/2 + " %",
            "inside": false,
            "lineAlpha": 0,
            "value": maxErrorRate/2,
            "toValue": maxErrorRate/2,
            "valueAxis": "errorAxis",
            "tickLength": 0
          },
          {
            "label": maxErrorRate + " %",
            "inside": false,
            "lineAlpha": 0,
            "value": maxErrorRate,
            "toValue": maxErrorRate,
            "valueAxis": "errorAxis",
            "tickLength": 0
          }
        ],
        "valueAxes": [
          {
            "id": "responseAxis",
            "maximum": maxResponses,
            "minimum": 0,
            "position": "left",
            "unit": " ms",
            "gridAlpha": 0,
            "labelsEnabled": false,
            "labelFrequency": 1000
          },{
            "id": "errorAxis",
            "maximum": maxErrorRate,
            "minimum": 0,
            "position": "right",
            "unit": " %",
            "gridAlpha": 0,
            "labelsEnabled": false,
            "labelFrequency": 1000
          }
        ],
        "allLabels": [],
        "balloon": {},
        "legend": {},
        "titles": [],
        "dataProvider": chartData
      }
    );
}
