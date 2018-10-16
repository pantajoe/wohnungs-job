$(document).on('turbolinks:load', function() {
  createChart(
    gon.lastDayOfMonth,
    gon.monthName,
    gon.requests,
    gon.errorRates,
    gon.responseTimes
  );
});

function createChart(days, month, requests, errors, responses){
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
          "#007D9D"
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
        "chartCursor": {
          "enabled": true,
          cursorColor: "#007D9D"
        },
        "trendLines": [],
        "graphs": [
          {
            "balloonText": "[[title]]: [[value]] ms",
            "balloon": {
              "borderThickness": 0,
              "color": "#FFFFFF",
              "fillColor": "#008990",
              "fillAlpha": 1.0
            },
            "bullet": "none",
            "id": "responseGraph",
            "title": "Antwortzeit",
            "valueField": "responseTime",
            "lineThickness": 1.5
          },
          {
            "balloonText": "[[title]]: [[value]] %",
            "balloon": {
              "borderThickness": 0,
              "color": "#FFFFFF",
              "fillColor": "#FF546A",
              "fillAlpha": 1.0
            },
            "bullet": "none",
            "id": "errorsGraph",
            "title": "Fehlerrate",
            "valueAxis": "errorAxis",
            "valueField": "errorRate",
            "lineThickness": 1.5
          }
        ],
        "guides": [
          {
            "label": maxResponses/4 + " ms",
            "inside": false,
            "lineAlpha": 0.2,
            "value": maxResponses/4,
            "toValue": maxResponses/4,
            "valueAxis": "responseAxis",
            "tickLength": 0
          },
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
            "label": (maxResponses/4)*3 + " ms",
            "inside": false,
            "lineAlpha": 0.2,
            "value": (maxResponses/4)*3,
            "toValue": (maxResponses/4)*3,
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
            "label": maxErrorRate/4 + " %",
            "inside": false,
            "lineAlpha": 0,
            "value": maxErrorRate/4,
            "toValue": maxErrorRate/4,
            "valueAxis": "errorAxis",
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
            "label": (maxErrorRate/4)*3 + " %",
            "inside": false,
            "lineAlpha": 0,
            "value": (maxErrorRate/4)*3,
            "toValue": (maxErrorRate/4)*3,
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
        "balloon": {
        },
        "legend": {
          "enabled": true,
          "valueText": ""
        },
        "titles": [],
        "dataProvider": chartData,
        "responsive": {
          "enabled": true
        }
      }
    );
}
