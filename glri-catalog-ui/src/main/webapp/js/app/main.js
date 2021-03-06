/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

var appState = {
	dynamicTable : null,	//Ref to the Dynatable object
	resourceType : null,	//user selected resource type to filter by
	rawResult : null,		//JS object constructed from JSON returned from query service request
	
	//A list of facets that we always look for.
	//Possibly in the future we could check for the existance of others add
	//add them to the current list.
	PERMANENT_RESOURCE_FACET_NAMES : ["Data", "Publication", "Project"],
	RESOURCE_TYPE_ANY : "Any",
	
	currentFacets : {},
	
	updateRawResults : function(unfilteredJsonData) {
		this.rawResult = unfilteredJsonData;
		this.updateFacetCount(unfilteredJsonData.searchFacets[0].entries);
	},
	
	updateFacetCount : function(facetJsonObject) {

		//reset all facets to zero
		for (var i in this.PERMANENT_RESOURCE_FACET_NAMES) {
			var term = this.PERMANENT_RESOURCE_FACET_NAMES[i];
			this.currentFacets[term] = count;
			$('#resource_input .btn input[value=' + term + '] + span').html(0);
		}
		
		for (var i in facetJsonObject) {
			var term = facetJsonObject[i].term;
			var count = facetJsonObject[i].count;

			this.currentFacets[term] = count;
			$('#resource_input .btn input[value=' + term + '] + span').html(count);
		};
	},
			
	updateResourceFilter : function(newResourceType) {
		this.resourceType = newResourceType;
		
		if (this.dynamicTable != null) {
			//need to update the table
			
			tableDataReady(this.rawResult);
		}
		
	},
	
	getFilteredResults : function() {
		if (this.resourceType != null && this.resourceType.length > 0 && this.rawResult != null) {
			
			if (this.resourceType == this.RESOURCE_TYPE_ANY) {
				return this.rawResult;
			} else {
				var data = new Object();
				data.items = new Array();

				for (var i in this.rawResult.items) {
					var item = this.rawResult.items[i];
					if (item.browseCategories[0] == this.resourceType) {
						data.items.push(item);
					}
				}

				return data;
			}
		} else {
			return this.rawResult;
		}
	}
	
};

$(document).ready(function(){
    // Sets up click behavior on all button elements with the alert class
    // that exist in the DOM when the instruction was executed
	$.dynatableSetup({
		features: {
		  paginate: false,
		  sort: true,
		  pushState: true,
		  search: false,
		  recordCount: false,
		  perPageSelect: false
		},
		params: {
			records: "_root"
		}
	});
	
    $("#loc_type_input").on( "change", function(event) {updateLocationList(event)});
	
    $("#query-submit").on( "click", function(event) {
		event.preventDefault();
		event.stopPropagation();
		updateTable();
    });
	
	/* Kick off the fancy selects */
	$('.selectpicker').selectpicker();
	
	/* Init Resource type picker */
	$('#resource_input .btn').click(function(event) {
		//appState.resourceType = event.target.children[0].value;
		
		appState.updateResourceFilter(event.target.children[0].value);
	});
	
	initSelectMap();
});



function updateTable() {
	var url = buildDataUrl();
	console.log( "Submitting the AJAX Request as: " + url);
	
	$("table.hidden").show();
	
	$.ajax({
		dataType: "json",
		url: url,
		success: tableDataReady
	});

	
}



var tableDataReady = function(data) {
	
	appState.updateRawResults(data);
	data = appState.getFilteredResults();
	
	
	
	var records = data.items;
	
	for (i=0; i<data.items.length; i++) {
		var item = data.items[i];
		var link = item['link']['url'];
		item['url'] = link;
		
		var resource = item['browseCategories'][0];
		item['resource'] = resource;
		
		var contacts = item['contacts'];
		for (j=0; j<contacts.length; j++) {
			var contact = contacts[j];
			var type = contact['contactType'];
			
			if (type == null) type = contact['type'];
			
			if ("Point of Contact" == type) {
				item['contact'] = contact['name'] + " (Point of Contact)";
				break;
			} else if ("Author" == type) {
				item['contact'] = contact['name'] + " (Author)";
				break;
			} else if ("Project Chief" == type) {
				item['contact'] = contact['name'] + " (Project Chief)";
				break;
			} else {
				item['contact'] = "???"
			}
			
		}
	}
	
	if (appState.dynamicTable == null) {
		$("#query-results-table").dynatable({
			dataset: {
				records: records
			},
			writers: {
				_cellWriter: writeCell
			}
		});
		
		appState.dynamicTable = $("#query-results-table").data('dynatable');
	} else {
		appState.dynamicTable.processingIndicator.show();
		appState.dynamicTable.records.updateFromJson(records);
		appState.dynamicTable.dom.update();
		appState.dynamicTable.processingIndicator.hide();

	}
	
};

function writeCell(column, record) {
    var html = glriAttributeWriter(column, record);
    var td = '<td';

    if (column.hidden || column.textAlign) {
      td += ' style="';

      // keep cells for hidden column headers hidden
      if (column.hidden) {
        td += 'display: none;';
      }

      // keep cells aligned as their column headers are aligned
      if (column.textAlign) {
        td += 'text-align: ' + column.textAlign + ';';
      }

      td += '"';
    }
	
    html = td + '>' + html + '</td>';
	
	return html;
 };
 
 function glriAttributeWriter(column, record) {

	var text;
	var id = column['id'];
	var val = record[id];
	
	if (id == "url") {
		text = "<a href=\"" + val + "\" target=\"_blank\">link</a>";
	} else if (id == "title") {
		
		var type = record['resource'];
		
		
		text = "<a class=\"resource-type\" title=\"" + type + ": Click to go directly to this record in ScienceBase\" href=\"" + record["url"] + "\" target=\"_blank\">";
		
		text += "<img src=\"style/image/";
		
		if ("Data" == type) {
			text += "data.svg";
		} else if ("Project" == type) {
			text += "project.svg";
		} else if ("Publication" == type) {
			text += "publication.svg";
		} else {
			text += "unknown_type.svg";
		}
		
		text += "\"/>";
		
		text += "</a>";
		
		text += "<h5>" + val + "</h5>";
	} else {
		text = record[id];
	}
    return text;
 };

function buildDataUrl() {
	var url = $("#sb-query-form").attr("action");
	url += "?" + $("#sb-query-form :input[name!='resource']").serialize();
	return url;
}

function updateLocationList(event) {
	
	//location type just selected by the user
	var typeSelection = event.currentTarget.options[event.currentTarget.selectedIndex].value;
	
	$("#loc_name_input optgroup").each(function() {
		if (this.label.indexOf(typeSelection + "s") == 0) {
			$(this).removeAttr("disabled");
		} else {
			$(this).attr("disabled", "disabled");
		}
	});
	
	//No location selection made prior to this is valid, so clear out.
	$("#loc_name_input").val("");
	$("#loc_name_input").selectpicker('refresh')
}


///////////
// Map Functions
///////////
function initSelectMap() {
	
	var lon = -85.47;
	var lat = 45.35;
	var zoom = 5.25;
	var map, wmsLayer, boxLayer;
	
	map = new OpenLayers.Map('map');

	wmsLayer = new OpenLayers.Layer.WMS( "OpenLayers WMS",
		"http://vmap0.tiles.osgeo.org/wms/vmap0?", {layers: 'basic'});

	boxLayer = new OpenLayers.Layer.Vector("Box layer");

	map.addLayers([wmsLayer, boxLayer]);
	map.addControl(new OpenLayers.Control.LayerSwitcher());
	map.addControl(new OpenLayers.Control.MousePosition());

	boxControl = new OpenLayers.Control.DrawFeature(boxLayer,
			OpenLayers.Handler.RegularPolygon, {
				handlerOptions: {
					sides: 4,
					irregular: true
				}
			}
		);

	// register a listener for removing any boxes already drawn
	boxControl.handler.callbacks.create = function(data) {
		if(boxLayer.features.length > 0) {
			boxLayer.removeAllFeatures();
		}
	};
	
	// register a listener for drawing a box
	boxControl.events.register('featureadded', boxControl,
			function(f) {

		// Variables for the geometry are: bottom/left/right/top
		// Sciencebase requires bounds to look like: [xmin,ymin,xmax,ymax]
		var extent = "["
				+ f.feature.geometry.bounds.left + ","
				+ f.feature.geometry.bounds.bottom
				+ "," + f.feature.geometry.bounds.right
				+ "," + f.feature.geometry.bounds.top
				+ "]";

		$('#xmin_label').val(f.feature.geometry.bounds.left);
		$('#ymin_label').val(f.feature.geometry.bounds.bottom);
		$('#xmax_label').val(f.feature.geometry.bounds.right);
		$('#ymax_label').val(f.feature.geometry.bounds.top);

		$('#spatial').val(extent);
	});


	map.addControl(boxControl);
	map.setCenter(new OpenLayers.LonLat(lon, lat), 5);
	
	$('#drawBox').click(function() {
		if($(this).is(':checked')) {
			boxControl.handler.stopDown = true;
			boxControl.handler.stopUp = true;
			boxControl.activate();
		} else {
			boxControl.handler.stopDown = false;
			boxControl.handler.stopUp = false;
			boxControl.deactivate();
		}
	});
	
	$('#clearMapButton').click(function() {
		$('#spatial').val('');
		$('#xmin_label').val('-');
		$('#ymin_label').val('-');
		$('#xmax_label').val('-');
		$('#ymax_label').val('-');

		boxLayer.removeAllFeatures();
		map.setCenter(new OpenLayers.LonLat(lon, lat), 5);				
	});
	
}

