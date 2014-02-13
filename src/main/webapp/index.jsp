<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		
		
		<!-- Tomcat 7 only 
		<script type="text/javascript" src="webjars/jquery/2.1.0/jquery.js"></script>
		-->
		<script type="text/javascript" src="js/lib/jquery/2.1.0/jquery.js"></script>
		<script type="text/javascript" src="js/lib/jquery-dynatable/0.3.1/jquery.dynatable.js"></script>
		
		<script type="text/javascript" src="js/app/main.js"></script>
		
		<link rel="stylesheet" type="text/css" href="js/lib/jquery-dynatable/0.3.1/jquery.dynatable.css" />
		<link rel="stylesheet" type="text/css" href="style/css/usgs_style_main.css" />
		<link rel="stylesheet" type="text/css" href="style/css/table.css" />
		<link rel="stylesheet" type="text/css" href="style/css/app.css" />
		<link rel="stylesheet" type="text/css" href="style/css/left-nav.css" />
		
		<!-- Twitter Bootstrap -->
		<script type="text/javascript" src="js/lib/bootstrap/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="js/lib/bootstrap-select/bootstrap-select.min.js"></script>
		<link rel="stylesheet" type="text/css" href="js/lib/bootstrap/css/bootstrap.min.css"/>
		<link rel="stylesheet" type="text/css" href="js/lib/bootstrap-select/bootstrap-select.min.css"/>
		
		<!-- Our Bootstrap Theme -->
		<script type="text/javascript" src="style/themes/theme1/theme1.js"></script>
		<link rel="stylesheet" type="text/css" href="style/themes/theme1/theme1.css"/>
		
		<!-- OpenLayers -->
		<script type="text/javascript" src="js/lib/OpenLayers/OpenLayers.js"></script>
		
        <title>Science Base Sample Query Page</title>
    </head>
    <body>
		<jsp:include page="template/header.jsp" flush="true" />
	<div class="container-fluid glri_content">
		<div id="main_page" class="page_body_content">
			<div class="row">
				<div class="col-xs-12">
					<div class="well well-sm">
						<h1>GLRI to ScienceBase Query API Example</h1>
						<p>All query are being submitted to the ScienceBase REST API.</p>
						<p>
							Choosing the <b>GLRI Results Only</b> option limits the results to the
							<a href="https://www.sciencebase.gov/catalog/item/52e6a0a0e4b012954a1a238a">Great Lakes Restoration Initiative</a>
							community of datasets.
						</p>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-3" style="width: 366px;">
					<%-- 			<form role="form" id="sb-query-form" action="${context}/sciencebasequery" method="POST"> --%>
					<form id="sb-query-form" action="ScienceBaseService">
						<div class="row">
							<div class="col-xs-12">
								<div class="well">
									<div class="row">
										<div class="col-xs-12">
											<div id="map" class="boundingMap"></div>
										</div>
									</div>
									<div class="row" style="margin-bottom: 20px;">
										<div class="col-xs-4">
											<div class="row">
												<div class="col-xs-12">
													<div class="checkbox">
														<label>
															<input type="checkbox" name="drawBox" id="drawBox" value="box"> Draw Bounds
														</label>
													</div>
												</div>
												<div class="col-xs-12">
													<button id="clearMapButton" type="button" class="btn btn-default btn-xs" style="margin-left: 6px;">Clear Map Filter</button>						
												</div>
											</div>
										</div>
										<div class="col-xs-8" style="padding-right: 19px">
											<div class="row">
												<div class="col-xs-6 boundsGroup">
													<div class="input-group input-group-sm">
														<span class="input-group-addon boundsValue">xMin</span>
														<input id="xmin_label" type="text" class="form-control boundsValue" style="" placeholder="-" disabled>
													</div>
												</div>
												<div class="col-xs-6 boundsGroup">
													<div class="input-group input-group-sm">
														<span class="input-group-addon boundsValue">yMin</span>
														<input id="ymin_label" type="text" class="form-control boundsValue" style="" placeholder="-" disabled>
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-xs-6 boundsGroup">
													<div class="input-group input-group-sm">
														<span class="input-group-addon boundsValue">xMax</span>
														<input id="xmax_label" type="text" class="form-control boundsValue" style="" placeholder="-" disabled>
													</div>
												</div>
												<div class="col-xs-6 boundsGroup">
													<div class="input-group input-group-sm">
														<span class="input-group-addon boundsValue">yMax</span>
														<input id="ymax_label" type="text" class="form-control boundsValue" style="" placeholder="-" disabled>
													</div>
												</div>
												<input type="hidden" id="spatial" name="spatial" value="">
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-xs-12">		
											<div class="row" style="padding-bottom: 10px;">
												<div class="col-xs-4">
													<label class="filter_label pull-right">Text Search</label>
												</div>
												<div class="col-xs-8">
													<input type="text" class="form-control" id="text_query" name="text_query" style="width: 98%;">
												</div>
											</div>     
		                                             <div class="row">
												<div class="col-xs-4">
													<label class="filter_label pull-right">Resource Type</label>
												</div>
												<div class="col-xs-8">
													<select class="selectpicker pull-left" name="resource" id="resource_input" multiple title="Any" data-width="98%">
														<option value="Data">Data</option>
														<option value="Publication">Publication</option>
														<option value="Project">Project</option>
													</select>
												</div>
											</div>
											<div class="row">
												<div class="col-xs-4">
													<label class="filter_label pull-right">GRRI Study Area</label>
												</div>
												<div class="col-xs-8">
													<select class="selectpicker pull-left" name="area" id="area_input" multiple title="Any" data-width="98%">
														<option value="Lake Michigan Basin">Lake Michigan Basin</option>
														<option value="Lake Erie Basin">Lake Erie Basin</option>
														<option value="Lake Huron Basin">Lake Huron Basin</option>
														<option value="Lake Superior Basin">Lake Superior Basin</option>
														<option value="Lake Ontario Basin">Lake Ontario Basin</option>
													</select>
												</div>
											</div>
											<div class="row">
												<div class="col-xs-4">
													<label class="filter_label pull-right">Focus Area</label>
												</div>
												<div class="col-xs-8">
													<select class="selectpicker pull-left" name="focus" id="focus_input" multiple title="Any" data-width="98%">
														<option value="Toxic Substances">Toxic Substances</option>
														<option value="Invasive Species">Invasive Species</option>
														<option value="Nearshore Health">Nearshore Health</option>
														<option value="Habitat & Wildlife">Habitat &amp; Wildlife</option>
														<option value="Accountability">Accountability</option>
													</select>
												</div>
											</div>
											<div class="row" style="margin-top: 10px;">
												<div class="col-xs-12">
													<select class="selectpicker pull-left adjustDropDown" name="format" id="format" title="Result Format" data-style="btn-xs" data-width="auto">
														<option value="json">JSON</option>
														<option value="html">HTML</option>
														<option value="xml">XML</option>
													</select>
													<div class="checkbox pull-left" style="margin-left: 20px;">
														<label style="white-space: nowrap;">
															<input type="checkbox" name="glri_only" id="glri_only" value="true" checked> GLRI Results Only?
														</label>
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-xs-12">
													<input class="btn btn-primary btn-sm" id="query-submit" type="submit" value="Search"/>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="" style="padding-right:20px; margin-top: -50px;">
					<table id="query-results-table">
						<thead>
							<tr>
								<th>Resource</th>
								<th>id</th>
								<th>title</th>
								<th>summary</th>
							</tr>
						</thead>
						<tbody>

						</tbody>
					</table>
					</div>
				</div>				
			</div>
		</div>
	</div>
		
		<script type="text/javascript">
			$(document).ready(
				function() {
					/* Kick off the fancy selects */
					$('.selectpicker').selectpicker();
		
					/**
					 * Build the OpenLayers map
					 */
					var boxControl;
		
					var lon = -85.47;
					var lat = 45.35;
					var zoom = 5.25;
					var map, wmsLayer, boxLayer;
		
					function init() {
						map = new OpenLayers.Map('map');
		
						wmsLayer = new OpenLayers.Layer.WMS("OpenLayers WMS",
								"http://vmap0.tiles.osgeo.org/wms/vmap0?", {
									layers : 'basic'
								});
		
						boxLayer = new OpenLayers.Layer.Vector("Box layer");
		
						map.addLayers([ wmsLayer, boxLayer ]);
						map.addControl(new OpenLayers.Control.LayerSwitcher());
						map.addControl(new OpenLayers.Control.MousePosition());
		
						boxControl = new OpenLayers.Control.DrawFeature(boxLayer,
								OpenLayers.Handler.RegularPolygon, {
									handlerOptions : {
										sides : 4,
										irregular : true
									}
								});
		
						// register a listener for removing any boxes already drawn
						boxControl.handler.callbacks.create = function(data) {
							if (boxLayer.features.length > 0) {
								boxLayer.removeAllFeatures();
							}
						}
		
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
					}
		
					init();
		
					$('#drawBox').click(function() {
						if ($(this).is(':checked')) {
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
				});
		</script>
		<jsp:include page="template/footer.jsp" flush="true" />
    </body>
</html>
