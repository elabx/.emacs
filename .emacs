var deleteMessage = "Todavía no has guardado ningun reporte. La forma se borrará por completo y empezaras un nuevo registro";
var deleteMessageAfterSave = function(){
    var text = "";
    
    text += "El reporte número: ";
    text += selectedReport;
    text += " es el último reporte guardado. ¿Deseas borrar la forma y empezar un nuevo registro?";
    
    return text;
}


var reportHasBeenSaved = false;

var estados = ["Aguascalientes"
	       ,"Baja California"
	       ,"Baja California Sur"
	       ,"Campeche"
	       ,"Chiapas"
	       ,"Chihuahua"
	       ,"Ciudad de México"
	       ,"Coahuila"
	       ,"Colima"
	       ,"Durango"
	       ,"Estado de México "
	       ,"Guanajuato"
	       ,"Guerrero"
	       ,"Hidalgo"
	       ,"Jalisco"
	       ,"Michoac"
	       ,"Morelos"
	       ,"Nayarit "
	       ,"Nuevo León "
	       ,"Oaxaca "
	       ,"Puebla "
	       ,"Querétaro"
	       ,"Quintana Roo"
	       ,"San Luis Potosí" 
	       ,"Sinaloa"
	       ,"Sonora" 
	       ,"Tabasco"
	       ,"Tamaulipas"
	       ,"Tlaxcala"
	       ,"Veracruz"
	       ,"Yucatán"
	       ,"Zacatecas"];

var reportTrataForm;
var reportValidationForm;

var a;

var  disableSubmitButtonCustom;

disableSubmitButtonCustom  = function()
{
    this.domEl.find(".alpaca-form-button-submit").attrProp("disabled", true);
    if ($.mobile)
    {
        try { $(".alpaca-form-button-submit").button('refresh'); } catch (e) { }
    }
};

var  enableSubmitButtonCustom;

enableSubmitButtonCustom =  function()
{
    this.domEl.find(".alpaca-form-button-submit").attrProp("disabled", false);
    if ($.mobile)
    {
        try { $(".alpaca-form-button-submit").button('refresh'); } catch (e) { }
    }
};

var debug;

var reportTrataSchema;

var reportTrataView = {
    "parent":"bootstrap-edit",
    "layout":{
	"template":"main",
	"bindings":{
	    "origenDelReporte":"#origenDelReporte",
	    "reportDate":".reportDate",
	    "numeroIdentificado":"#numeroIdentificado",
	    "llamanteIdentificado":"#llamanteIdentificado",
	    "nombreLlamante":"#nombreLlamante",
	    "tipoLlamante":"#tipoLlamante",
	    "callerMunicipality":"#callerMunicipality",
	    "generoLlamante":"#generoLlamante",
	    "state":"#state",
	    "edadVictimaEsLlamante":"#edadVictimaEsLlamante",
	    "country":"#country",
	    "nationality":"#nationality",
	    "phone":"#phone",
	    "phoneType":"#phoneType",
	    "email":"#email",
	    "puedeSerContactado":"#puedeSerContactado",
	    "medioContacto":"#medioContacto",
	    "diaHoraContacto":"#diaHoraContacto",
	    "victimDataGiven":"#victimDataGiven",
	    "datosVictima":"#datosVictima",
	    "datosExplotacion":"#datosExplotacion",
	    "hechosDescripcion":"#hechosDescripcion",
	    "lugarDeLosHechos":"#lugarDeLosHechos",
	    "victimasNoIdentificadas":"#victimasNoIdentificadas",
	    "possibleResponsibles":"#possibleResponsibles",
	    "mediosTransporte":"#mediosTransporte",
	    "observacionesGenerales":"#observacionesGenerales",
	    "tipoDeCaso":"#tipoDeCaso",
	    "notasSeguimiento":"#notasSeguimiento"
	    
	}
    },  
    "templates":{
	"main": "/consejo-nomastrata-portlet/templates/trataMain.html"
    },
    "messages":{
	"es_ES":{
	    "invalidEmail":"Formato inválido de correo electrónico. Ejemplo: usuario@servidorcorreos.com",
	    "stringTooShort": "Este campo debe contener por lo menos {0} números o caracteres."
	}
    },
    "locale":"es_ES"
};

var postRender = function(control){
    var sector = control.childrenByPropertyId["sector"];
    var sectorDetail = control.childrenByPropertyId["sectorDetail"];
    sectorDetail.subscribe(sector, function(val) {
        this.schema.enum = this.options.optionLabels = sector[val];
        this.refresh();
    });
}


var reportTrataOptions = {
    
    "fields":{

	"reportDate":{
	    "view":"bootstrap-display",
	    "picker":{
		locale:"es"
	    }
	},

	"tipoDeCaso":{
	    "type":"select",
	    "hideNone":false,
	    "noneLabel":"Selecciona una opcion..."
	    
	    
	},
	
	"observacionesGenerales":{
	    "hideInitValidationError": true,
	    "type":"textarea",
	    "helper":"Escribe sobre las ACCIONES que tomaste en el caso y demás observaciones pertinentes"
	},

	"notasSeguimiento":{
	    "type":"textarea"
	},
		
	"origenDelReporte":{
	    "noneLabel":"Selecciona un origen..."
	},

	"numeroIdentificado":{
	    "validate": true 	    
	},

	"nombreLlamante":{
	    "dependencies":{
		"llamanteIdentificado":"Identificada"
	    }
	},
	
	"llamanteIdentificado":{
	    
	    "hideNone":true
	},

	"tipoLlamante":{
	    "noneLabel":"Selecciona una opción..."  
	},

	//// Caller Type dependencies

	"edadVictimaEsLlamante":{
	    "sort":false,
	    "dependencies":{
		"tipoLlamante":["Víctima"]
	    }
	},
	
	"generoLlamante":{
	    "hideNone":false,
	    "type":"select",
	    "noneLabel":"Seleccciona una opción...", 
	    "dependencies":{
		"tipoLlamante":["Víctima",
				"Familiar",
				"Amigo",
				"Testigo",
				"Conoce la información"]
	    }
	},

	"callerMunicipality":{
	    "dependencies":{
		"tipoLlamante":["Víctima",
				"Familiar",
				"Amigo",
				"Testigo",
				"Conoce la información"]
	    }
	},
	
	"state":{
	    "dependencies":{
		"tipoLlamante":["Víctima",
				"Familiar",
				"Amigo",
				"Testigo",
				"Conoce la información"]
	    }
	},

	"country":{
	    "dependencies":{
		"tipoLlamante":["Víctima",
				"Familiar",
				"Amigo",
				"Testigo",
				"Conoce la información"]
	    }
	},

	"nationality":{
	    "dependencies":{
		"tipoLlamante":["Víctima",
				"Familiar",
				"Amigo",
				"Testigo",
				"Conoce la información"]
	    }
	},

	"phone":{
	    "type":"integer",
	    "showMessages":true,
	    "dependencies":{
	    	"tipoLlamante":["Víctima",
				"Familiar",
				"Amigo",
				"Testigo",
				"Conoce la información"]
	    },
	    "helper": "El número debe de tener por lo menos 10 dígitos."
	},
	
	"phoneType":{
	    "hideNone": true,
	    "dependencies":{
	    	"tipoLlamante":["Víctima",
				"Familiar",
				"Amigo",
				"Testigo",
				"Conoce la información"]
	    }
	},
	
	"email":{
	    "type":"email",
	    //"validate":"true",
	    "dependencies":{
	    	"tipoLlamante":["Víctima",
				"Familiar",
				"Amigo",
				"Testigo",
				"Conoce la información"]
	    }
	},

	
	/// END Caller type dependencies

	"hechosDescripcion":{
	    "hideInitValidationError": true,
	    "type":"textarea",
	    "label":"Circunstancias de tiempo y modo",
	    "rows":10,
	    "helper":"No olvides describir las acciones (captación, enganche, transporte, transferencia, retención, entrega, recepción, alojamiento) y los medios (engaño, violencia física o moral, abuso de poder, amenaza, etc. que el tratante utiliza para lograr la explotación"
	},

	"observaciones":{
	    "type":"textarea",
	    "label":"Observaciones",
	    "rows":5
	},

	"caseType":{
	    "type":"select",
	    "noneLabel": "Selecciona una opción...",
            "removeDefaultNone": false
	},

	"observacionesVictima":{
	    "type":"textarea",
	    "label":"Observaciones",
	    "rows":5
	},
	
	"puedeSerContactado":{
	    "label": "Puede ser contactado",
	    "dependencies":{
		"tipoLlamante":["Víctima",
				"Familiar",
				"Amigo",
				"Testigo",
				"Conoce la información"]
	    }
	},

	"medioContacto":{
	    "hideNone":true,
	    "dependencies":{
		"puedeSerContactado":true
	    }
	},
	
	"diaHoraContacto":{
	    // "type":"datetime",
	    "dependencies":{
		"puedeSerContactado":true
		
	    }
	    // "picker":{
	    // 	locale:"es",
	    // 	"sideBySide": true
	    // }
	    
	},

	"datosExplotacion":{
	    "type":"select",
	    "removeDefaultNone":true,
	    "noneLabel":"Selecciona uno...",
	    "multiselect": {
		"enableFiltering": false,
		"numberDisplayed": 100,
		"nonSelectedText":"Selecciona uno..."
	    },
	    "multiple": true,
	    "hideInitValidationError": true
	},


	
	"possibleResponsibles":{
	    "type":"array",
	    "hideToolbarWithChildren":false,
	    "toolbarSticky":true,
	    "items":{
		"fieldClass":"nestedArray",
		"fields":{

		    "possibleResponsiblesArrayId":{
			 "hidden":true,
			"default":0
		    },

		    "sexo":{
			"type":"select",
			"fieldClass":"col-md-2",
			"noneLabel":"Selecciona uno..."

		    },
		    
		    "function":{
			"fieldClass":"col-md-2",
			"type":"select",
			"removeDefaultNone":true,

			"multiselect": {
			    "enableFiltering": true,
			    "includeSelectAllOption": true,
			    "nonSelectedText":"Selecciona uno...",
			    "selectAllText": 'Seleccionar todos'
			    
			},
			"multiple": true,
			"hideInitValidationError": true 
		    },
		    "name":{
			"fieldClass":"col-md-4"
		    },
		    "age":{
			"fieldClass":"col-md-4"
		    },
		    "address":{
			"fieldClass":"col-md-4"
		    },
		    "particularSigns":{
			"fieldClass":"col-md-4"
		    },
		    "affiliation":{
			"fieldClass":"col-md-4"
		    },
		    "victimRelationship":{
			"fieldClass":"col-md-4"
		    },
		    "observacionesVictima":{
			"fieldClass":"col-md-10"
		    }
		    
		}
	    },
	    "toolbar":{
		"actions":[{
		    "action":"add",
		    "label":"Agregar nuevo"
		}]
            }
	},
	"mediosTransporte":{
	    "type":"array",
	    "items":{
		"fieldClass":"nestedArray",
		"fields":{
		    "transporteArrayId":{
			"fieldClass":"col-md-6",
			"hidden":true
		    },
		    "tipoDeTransporte":{
			"fieldClass":"col-md-6",
			"noneLabel":"Selecciona uno...",
			"removeDefaultNone":false
		    },
		    "especifiqueTransporte":{
			"fieldClass":"col-md-6"
		    },
		    "placas":{
			"fieldClass":"col-md-6"
		    },
		    "caracteristicas":{
			"fieldClass":"col-md-6"
		    },
		    "uso":{
			"type":"select",
			"fieldClass":"col-md-6",
			"noneLabel":"Selecciona uno...",
			"removeDefaultNone":false

		    },
		    "ruta":{
			"fieldClass":"col-md-6"
		    },
		    "ubicacion":{
			"fieldClass":"col-md-6"
		    }
		}
	    },
	    "toolbarSticky":true,
	    "hideToolbarWithChildren":false,
	    
	    "toolbar":{
		"actions":[{
		    "action":"add",
		    "label":"Agregar nuevo"
		}]
            }
	},
	
	"contactedBy":{
	    "hideNone":true,
	    "dependencies":{  
	    	"puedeSerContactado": true
	    }
	},
	"victimDataGiven":{
	    "label": "Proporciona datos de la víctima",
	    "type":"checkbox",
	    "dependencies":{
		"tipoLlamante":["Familiar",
				"Amigo",
				"Testigo",
				"Conoce la información"]
	    }
	},
	
	"datosVictima":{
	    "focus":true,
	    "collapsible":true,
	    "toolbarSticky":true,
	    "hideToolbarWithChildren":false,
	    "type":"array",
	    "items":{
		"fieldClass":"nestedArray",
		"fields":{

		    "victimaArrayId":{
			"hidden":true
		    },
		    
		    "nombreVictima":{
			"fieldClass":"col-md-6"
		    },

		    "generoVictima":{
			"type":"select",
			"hideNone": true,
			"fieldClass":"col-md-6"
		    },

		    "edadVictima":{
			"fieldClass":"col-md-6",
			"sort":false,
			"type":"select"
		    },
		    
		    "origenVictima":{
			"fieldClass":"col-md-12"
		    },
		    "telefonoVictima":{
			"fieldClass":"col-md-4"
		    },
		    
		    "telefonoVictimaPertenece":{
			"fieldClass":"col-md-4"
		    },

		    "tipoTelefonoVictima":{
			"type":"select",
			"fieldClass":"col-md-4",
			"hideNone": true
		    },
		    
		    "mailVictima":{
			"fieldClass":"col-md-6",
			"type":"email"
			//"validate":true
		    },
		    "mailVictimaPertenece":{
			"fieldClass":"col-md-6"
		    },
		    "victimaPuedeSerContactado":{
			"fieldClass":"col-md-6"
		    },
		    
		    
		    "nacionalidadVictima":{
			"fieldClass":"col-md-6",
			"type":"select"
		    },
		    "victimaContactoMedio":{
			"hideNone":true,
			"fieldClass":"col-md-6"
		    },
		    "victimaContactoDiaHora":{
			"fieldClass":"col-md-6"
			//"type":"datetime"
		    }
		}
	    },
	    "dependencies":{
	    	"victimDataGiven": true
	    },
	    "toolbar":{
		"actions":[{
		    "action":"add",
		    "label":"Agregar nuevo"
		}]
            }
	    
	},

	"victimasNoIdentificadas":{
	    "actionbar":{
		"title":"Acciones"
	    },
	    "hideToolbarWithChildren":false,
	    "toolbarSticky":true,
	    "toolbar":{
		"actions":[{
		    "action":"add",
		    "label":"Agregar"
		}]
            },
	    "showActionsColumn":true,
	    "type":"table",
	    "items":{
		"fields":{

		    "victimasNoIdentificadasArrayId":{
			"hidden":true
		    },
		    
		    "sexo":{
			"noneLabel":"Selecciona uno...",
			"type":"select"
		    },
		    "rangoEdad":{
			"sort": false
		    }
		}
	    }
	},
	
	"lugarDeLosHechos":{
	    "collapsible":true,
	    "focus":true,
	    "hideToolbarWithChildren":false,
	    "toolbarSticky":true,
	    "toolbar":{
		"actions":[{
		    "action":"add",
		    "label":"Agregar nuevo"
		}]
            },
	    "items":{
		"fieldClass":"nestedArray",
		"fields":{
		    "observacionesLugar":{
			"fieldClass":"col-md-12"
			
		    },

		    "url":{
			"fieldClass":"col-md-6"
		    },
		    
		    "lugarArrayId":{
			"hidden":true
		    },

		    "pais":{
			"type":"select",
			"noneLabel":"Selecciona uno...",
			"fieldClass":"col-md-6",
			"removeDefaultNone":false
		    },
		    "estado":{
			"fieldClass":"col-md-6"
		    },
		    "region":{
			"fieldClass":"col-md-6" 
		    },
		    "colonia":{
			"fieldClass":"col-md-6"
		    },
		    "calle":{
			"fieldClass":"col-md-6"
		    },
		    "referencia":{
			"fieldClass":"col-md-6"
		    },
		    "tipoDeLugar":{
			"fieldClass":"col-md-6"
		    },
		    "tipoDeLugarOtro":{
			"fieldClass":"col-md-6"
		    },
		    "sector":{
			"fieldClass":"col-md-6",
			"type":"select",
			"noneLabel":"Selecciona uno...",
			"removeDefaultNone":false
			
		    },
		    
		    "tipoDeLugarOtro":{
			"fieldClass":"col-md-6",
			"dependencies":{
			    "tipoDeLugar": "Otro"
			}
		    },
		    
		    "detalleSectorAgropecuario":{
			"fieldClass":"col-md-12",
			"type":"select",
			"removeDefaultNone":false,
			"hideNone":false,
			"noneLabel":"Selecciona uno...",
			"dependencies":{
			    "sector":"Agropecuario"
			}
		    },
		    "detalleSectorMineria":{
			"fieldClass":"col-md-12",
			"type":"select",
			"removeDefaultNone":false,
			
			"hideNone":false,
			"noneLabel":"Selecciona uno...",
			"dependencies":{
			    "sector":"Mineria"
			}
		    },
		    "detalleSectorEnergetico":{
			"fieldClass":"col-md-12",
			"type":"select",
			"removeDefaultNone":false,
			
			"hideNone":false,
			"noneLabel":"Selecciona uno...",
			"dependencies":{
			    "sector":"Energetico"
			}
		    },
		    "detalleSectorConstruccion":{
			"fieldClass":"col-md-12",
			"type":"select",
			"removeDefaultNone":false,
			
			"hideNone":false,
			"noneLabel":"Selecciona uno...",
			"dependencies":{
			    "sector":"Construccion"
			}
		    },
		    "detalleSectorIndustriasManufactureras":{
			"fieldClass":"col-md-12",
			"type":"select",
			"removeDefaultNone":false,
			
			"hideNone":false,
			"noneLabel":"Selecciona uno...",
			"dependencies":{
			    "sector":"Industrias manufactureras"
			}
		    },
		    "detalleSectorComercioAlPorMayor":{
			"fieldClass":"col-md-12",
			"type":"select",
			"removeDefaultNone":false,
			
			"hideNone":false,
			"noneLabel":"Selecciona uno...",
			"dependencies":{
			    "sector":"Comercio al por mayor"
			}
		    },
		    "detalleSectorComercioAlPorMenor":{
			"fieldClass":"col-md-12",
			"type":"select",
			"removeDefaultNone":false,
			
			"hideNone":false,
			"noneLabel":"Selecciona uno...",
			"dependencies":{
			    "sector":"Comercio al por menor"
			}
		    },
		    "detalleSectorTransportesCorreosAlmacenamientos":{
			"fieldClass":"col-md-12",
			"type":"select",
			"removeDefaultNone":false,
			
			"hideNone":false,
			"noneLabel":"Selecciona uno...",
			"dependencies":{
			    "sector":"Transportes correos y almacenamiento"
			}
		    },
		    "detalleSectorInformacionMediosMasivos":{
			"fieldClass":"col-md-12",
			"type":"select",
			"removeDefaultNone":false,
			
			"hideNone":false,
			"noneLabel":"Selecciona uno...",
			"dependencies":{
			    "sector":"Informacion en medios masivos"
			}
		    },
		    "detalleSectorServicios":{
			"fieldClass":"col-md-12",
			"type":"select",
			"removeDefaultNone":false,
			
			"hideNone":false,
			"noneLabel":"Selecciona uno...",
			"dependencies":{
			    "sector":"Servicios"
			}
		    },
		    "detalleSectorOtrosServiciosExceptoGobierno":{
			"fieldClass":"col-md-12",
			"type":"select",
			"removeDefaultNone":false,
			"hideNone":false,
			"noneLabel":"Selecciona uno...",
			"dependencies":{
			    "sector":"Otros servicios excepto actividades gubernamentales"
			}
		    },
		    "detalleSectorActividadesGubernamentales":{
			"fieldClass":"col-md-12",
			"type":"select",
			"removeDefaultNone":false,
			"hideNone":false,
			"noneLabel":"Selecciona uno...",
			"dependencies":{
			    "sector":"Actividades gubernamentales"
			}
		    },
		    
		    "funcionDelLugar":{
			"fieldClass":"col-md-6",
			"removeDefaultNone":true,
			"hideNone":false,
			"noneLabel":"Selecciona uno..."
		    }
		    
		    
		}
	    },
	    "dependencies":{
	    	// "victimDataGiven": true
	    }
	    
	}
    },
    "form":{
	"buttons":{
	    "reset":{
		"styles":"btn-lg btn-primary pull-right",
		"label":"Nuevo registro",
		"click":function(e){
		    e.preventDefault();
		    if(!reportHasBeenSaved){
			var deleteForm = confirm(deleteMessage);
			if(!deleteForm){
			    return; 
			} else {
			    this.destroy();
			}
		    } else {
			var deleteForm = confirm(deleteMessageAfterSave());
			if(!deleteForm){
			    return; 
			} else {
			    this.destroy();
			}			
		    }
		    reportHasBeenSaved = false;
		    $("#createdReportSuccess").remove();
		    selectedReport = "";
		    $("#formTrata").alpaca(
			{
			    schema: reportTrataSchema,
			    options: reportTrataOptions,
			    view: reportTrataView,
			    "postRender":function(){
				console.log(	$(".alpaca-form-button-reset"));
				reportTrataForm = $("#formTrata").alpaca("get");
				//$(".alpaca-form-button-reset").prop("disabled", true);
				//$(".alpaca-form-button-reset").removeClass("btn-primary");   
				//$(".alpaca-form-button-reset").addClass("btn-default");
			    } 
			    
			});
		}
	    },
	    "submit":{
		"label": "Guardar",
		"styles":"btn-lg btn-primary pull-right",
		
		"click": function(e){
		    e.preventDefault();
		    console.log("clickes!!!");
		    var value = this.getValue();
		    debug = this;
		    //console.log(value);
		    var stringval = JSON.stringify(value);
		    //console.log(stringval);
		    this.disableSubmitButton();
		    if(selectedReport){
			console.log("starting ajax call...");
			$.ajax({url: ajaxSubmit,
				method: "post",
				data: {
				    reportContent: stringval,
				    reportId: selectedReport,
				    action:"updateReport"
				},
				success: function(data){
				    
				    var _data = data;
				    _data = JSON.parse(data);

				    console.log(_data.reportData);
				    console.log("report updated from front screen");
				    reportTrataForm.setValue(_data.reportData);
				    
				    $.notify(
					_data.success,{
					    "className": "success",
					    "globalPosition": "bottom right"
					});
	    			},
				"error": function(data){
				    console.log("errrrrrror");
				},

				"complete":function(){
				    console.log("update complete");
				}
				
			       });
		    } else {
			
			$.ajax({
	    		    url: ajaxSubmit,
	    		    method: "post",
	    		    data: {reportContent:stringval,
	    			   action:"addReportAction"
				  },
			    success: function(data){
				reportHasBeenSaved = true;
				var _data = data;
				_data = JSON.parse(data);
				console.log(_data.newReportId);
				console.log(_data.reportData);
				
				$(".consejo-nomastrata-portlet").append(
				    "<div id='createdReportSuccess' class='bootstrap-iso'>" +
					"<div id='' class='panel panel-success'>" +
					"<div class='panel-heading'>Se ha creado un caso</div>" +
					"<div class='panel-body'>"+
					"<h4>" +
					"Se ha creado el caso con número: " + _data.newReportId +
					"</h4>" +
					"</div>" +
					"</div>"
				);

				reportTrataForm.setValue(_data.reportData);
				
				selectedReport = _data.newReportId;

				$(".alpaca-form-button-submit")
				    .text("Actualizar registro: " + _data.newReportId)
				    .prop("disabled", false);
				// .remove();
				
				$.notify(
				    _data.success,{
					"className": "success",
					"globalPosition": "bottom right"
				    });
	    		    },
			    complete:function(){
				$(".alpaca-form-button-reset").prop("disabled", false);
				$(".alpaca-form-button-reset").removeClass("btn-default");
				$(".alpaca-form-button-reset").addClass("btn-primary");
				//$(".alpaca-form-button-submit").removeClass("btn-primary");
				//$(".alpaca-form-button-submit").addClass("btn-default");
			    }
			}); 
			
		    }
	    	}
	    }
	}
    }
};

var endFields = {
    "tipoDeLlamada":{
	"type":"string",
	"title":"Tipo de llamada",
	"enum":[
	    "CRISIS",
	    "ALTO RIESGO",
	    "INFORMATIVO",
	    "ASESORAMIENTO",
	    "CAPACITACIÓN y ASISTENCIA TÉCNICA",
	    "REFERENCIA",
	    "NO RELACIONADO",
	    "STATUS 2"
	]
    }
}

$(document).ready(function(){
    // console.log(mediosDeTransporteSchema.properties);
    // console.log(probablesResponsablesSchema.properties);

    var theForm = $.extend(datosLlamadaSchema.properties,
			   mediosDeTransporteSchema.properties, 
			   probablesResponsablesSchema.properties// ,
			   // endFields
			  );

    
    reportTrataSchema = {
	"type": "object",
	"title":"Reporte Trata de Personas"
    };
    
    reportTrataSchema.properties = theForm;
    reportTrataSchema.dependencies = datosLlamadaSchema.dependencies;

    console.log(reportTrataSchema);
    
    console.log(theForm);
    $("#formTrata").alpaca({
	"schema": reportTrataSchema,
	"options": reportTrataOptions,
	"view":reportTrataView,
	"postRender": function(){
	    console.log($(".alpaca-form-button-reset"));
	    $(".alpaca-form-button-reset").prop("disabled", false);
	    reportTrataForm = $("#formTrata").alpaca("get");
	    //$(".alpaca-form-button-reset").removeClass("btn-primary");
	    //$(".alpaca-form-button-reset").addClass("btn-default");
	}
    });
});

var selectedReport;

$(".table-cell a").click(function(e){
  
    e.preventDefault();
    selectedReport = $(e.currentTarget).text();
     //  $("#panel-report-number").html("<h5>" + selectedReport + "</h5>");
    // console.log("yelloooow");
    $.ajax({
	url: ajaxSubmit,
	method: "get",
	data: {
	    reportId: selectedReport,
	    action:"getReportContent" 
	},
	success: function(response, status){
	    var _response = JSON.parse(response);
	    
	    $("#panel-user-name").html(_response.user);
	    $("#panel-report-number").html("<p>" + selectedReport + "</p>");
	    
	    delete reportTrataOptions.form.buttons.reset;
	    reportTrataOptions.form.buttons.submit.click = function(e){
		var value = this.getValue();
		var stringval = JSON.stringify(value, null, "  ");
		e.preventDefault();
		$.ajax({url: ajaxSubmit,
			method: "post",
			data: {
			    reportContent: stringval,
			    reportId: selectedReport,
			    action:"updateReport"
			},
			success: function(data){
			    var _data = data;
			    _data = JSON.parse(data);
			    
			    console.log("report updated");
			    reportTrataForm.setValue(_data.reportData);
			    $.notify(
				_data.success,{
				    "className": "success",
				    "globalPosition": "bottom right"
				});
			}  
			
		       });
		
	    };

	   
	    var theformdata;
	    
	    if ($("#reportTrataForm").alpaca("exists")){
		console.log("form exists");
		$("#reportTrataForm").alpaca("destroy");
	    } else {
		console.log("not exists");	
		
	    }

	    
	    if ($("#validationTrataForm").alpaca("exists")){
		console.log("validator form exists");
		$("#validationTrataForm").alpaca("destroy");
	    } else {
		console.log("not exists");	
		
	    }

	    //console.log(_response.responseValidation);
	    
	    $("#reportTrataForm").alpaca(
		{
		    data: _response.reportContent,
		    schema: reportTrataSchema,
		    options: reportTrataOptions,
		    view: reportTrataView,
		    "postRender": function(){
			reportTrataForm = $("#reportTrataForm").alpaca("get");
			reportTrataForm.form.disableSubmitButton = disableSubmitButtonCustom;
			reportTrataForm.form.enableSubmitButton = enableSubmitButtonCustom;
			
		    }
		});
	    
	    if(portletName != "consejonomastrataseguimientoview"){
		$("#validationTrataForm").alpaca({
	    	    data: _response.reportValidation,
	    	    schema: validationTrataSchema,
	    	    options: validationTrataOptions,
	    	    view: validationTrataView,
		    "postRender": function(){
			reportValidationForm = $("#validationTrataForm").alpaca("get");
			reportValidationForm.form.enableSubmitButton = enableSubmitButtonCustom;
			reportValidationForm.form.disableSubmitButton = disableSubmitButtonCustom;
		    }
		});
	    }
	  
	}
    });
});


var validationTrataView = {
    "parent":"bootstrap-edit",
    "layout":{
	"template":"trataValidacionTemplate",
	"bindings":{
	    "casoRelacionado":"#casoRelacionado",
	    "casoRelacionadoRelacion":"#casoRelacionadoRelacion",
	    
	    "tipoDeFamiliar":"#tipoDeFamiliar",
	    "otroTipoDeFamiliar":"#otroTipoDeFamiliar",

	    "paisOrigenVictima":"#paisOrigenVictima",
	    "estadoOrigenVictima":"#estadoOrigenVictima",

	    "rangosEdadProbableResponsable":"#rangosEdadProbableResponsable",
	    "paisProbableResponsable":"#paisProbableResponsable",
	    "estadoProbableResponsable":"#estadoProbableResponsable",
	    "municipioProbableResponsable":"#municipioProbableResponsable",
	    
	    "actividadesIdentificadas":"#actividadesIdentificadas",
	    "formaCaptacion":"#formaCaptacion",
	    "mediosCaptacion":"#mediosCaptacion",
	    "trayectoSalida":"#trayectoSalida",
	    "intermedio":"#intermedio",
	    "destino":"#destino",
	    "rangoEdadCaptacion":"#rangoEdadCaptacion",
	    
	    "consecuenciasEnLaVictima":"#consecuenciasEnLaVictima",
	    "condicionesDeVulnerabilidadDeLaVictima":"#condicionesDeVulnerabilidadDeLaVictima",
	    "mediosComisivos":"#mediosComisivos",

	    "accionesDelConsejo":"#accionesDelConsejo",
	    "accionesDelLlamante":"#accionesDelLlamante",
	    "accionesDeLaAutoridad":"#accionesDeLaAutoridad",
	    
	    "observacionesValidador":"#observacionesValidador",

	    "asesoriaJuridica":"#asesoriaJuridica",
	    "asesoriaJuridicaInfo":"#asesoriaJuridicaInfo",
	    "atencionPsicologica":"#atencionPsicologica",
	    "atencionPsicologicaInfo":"#atencionPsicologicaInfo",
	    "canalizacionGobierno":"#canalizacionGobierno",
	    "canalizacionGobiernoInfo":"#canalizacionGobiernoInfo",
	    "canalizacionOrganizacionCivil":"#canalizacionOrganizacionCivil",
	    "canalizacionOrganizacionCivilInfo":"#canalizacionOrganizacionCivilInfo",
	    "acompanamientoFiscalia":"#acompanamientoFiscalia",
	    "acompanamientoFiscaliaInfo":"#acompanamientoFiscaliaInfo",
	    "derivacionRecompensa":"#derivacionRecompensa",
	    "derivacionRecompensaInfo":"#derivacionRecompensaInfo",
	    "envioOficio":"#envioOficio",
	    "envioOficioInfo":"#envioOficioInfo",
	    "instanciaDeCanalizacion":"#instanciaDeCanalizacion",
	    "respuestaDeCanalizacion":"#respuestaDeCanalizacion",
	    
	    "apoyoAlbergue":"#apoyoAlbergue",
	    "apoyoAlbergueInfo":"#apoyoAlbergueInfo",
	    "noCanalizado":"#noCanalizado",
	    "noCanalizadoInfo":"#noCanalizadoInfo",


	    "autoridadDenuncia":"#autoridadDenuncia",
	    "autoridadDenunciaInfo":"#autoridadDenunciaInfo",
	    "autoridadFecha":"#autoridadFecha",
	    "autoridadFechaInfo":"#autoridadFechaInfo",
	    "autoridadLugar":"#autoridadLugar",
	    "autoridadLugarInfo":"#autoridadLugarInfo",
	    "alertaAmber":"#alertaAmber",
	    "alertaAmberInfo":"#alertaAmberInfo",
	    "alertaAlba":"#alertaAlba",
	    "alertaAlbaInfo":"#alertaAlbaInfo",
	    "reporteProduraduria":"#reporteProduraduria",
	    "reporteProduraduriaInfo":"#reporteProduraduriaInfo",

	    "investigacion":"#investigacion",
	    "investigacionInfo":"#investigacionInfo",
	    // "averiguacionPrevia":"#averiguacionPrevia",
	    // "averiguacionPreviaInfo":"#averiguacionPreviaInfo",
	    "diligencia":"#diligencia",
	    "diligenciaInfo":"#diligenciaInfo",
	    "sentencia":"#sentencia",
	    "sentenciaInfo":"#sentenciaInfo",
	    "personasRescatadas":"#personasRescatadas",
	    "personasRescatadasInfo":"#personasRescatadasInfo",

	    "clasificacionTdp":"#clasificacionTdp"
	    
	}
    },
    "templates":{
	"trataValidacionTemplate":"/consejo-nomastrata-portlet/templates/trataValidacionTemplate.html"
    },
    "locale":"es_ES"
};

var validationTrataSchema = {
    "title":"Validacion de reporte de Trata de Personas",
    "type":"object",
    "properties":{
	"observacionesValidador":{
	    "title":"Observaciones del validador",
	    "required":true,
	    "type":"string"
	},
	
	"tipoDeFamiliar":{
	    "title":"Tipo de familiar",
	    "type":"string",
	    "enum":["Padre/Madre",
		    "Hermano(a)",
		    "Pareja/Esposo/Novio",
		    "Tío(a)", "Primo(a)", "Otro"]
	},
	"otroTipoDeFamiliar":{
	    "title":"Otro (tipo de familiar)",
	    "type":"string"
	},

	"paisOrigenVictima":{
	    "title":"País de origen de la víctima",
	    "type":"string",
	    "enum": paises
	    
	},

	"estadoOrigenVictima":{
	    "title":"Estado de origen de la víctima",
	    "type":"string",
	    "enum": estados
	},

	"rangosEdadProbableResponsable":{
	    "title":"Rangos de edad de probable responsable",
	    "type":"string",
	    "enum":["0 a 3",
		    "4 a 6",
		    "7 a 12",
		    "13 a 17",
		    "18 a 24",
		    "25 a 31",
		    "32 a 38",
		    "39 a 45",
		    "46 a 52",
		    "53 a 59",
		    "60 a 69",
		    "70 a 79",
		    "80 en adelante"]
	},

	"paisProbableResponsable":{
	    "title":"País de origen del probable responsable",
	    "type":"string",
	    enum:paises
	},

	"estadoProbableResponsable":{
	    "title":"Estado de ubicación probable responsable",
	    "type":"string",
	    enum:estados
	},

	"municipioProbableResponsable":{
	    "title":"Municipio/Delegación de ubicación probable responsable",
	    "type":"string"
	    
	},

	"actividadesIdentificadas":{
	    "title":"Actividades identificadas",
	    "type":"string",
	    "enum":[
		"Captación",
		"Enganche",
		"Transporte",
		"Transferencia",
		"Retención", 
		"Entrega",
		"Recepción",
		"Alojamiento",
		"Preparación",
		"Promoción",
		"Incitación",
		"Facilitación",
		"Colaboración"]
	},

	"formaCaptacion":{
	    "title":"Forma de captación",
	    "type":"string",
	    "enum":[
		"Académica / Apadrinamiento",
		"Promesa de superacion personal",
		"Promesa de viajes al extranjero",
		"Matrimonios pactados",
		"Convocatoria",
		"Espacios de internamiento (reclusion/penal, medico o tratamiento terapeutico/anexos)"
	    ]
	},
	
	"mediosCaptacion":{
	    "title":"Medios de captación",
	    "type":"string",
	    "enum":["Clasificados",
		    "Bolsa de trabajo internet",
		    "Redes sociales",
		    "Recomendacion",
		    "Personal",
		    "Foyer"]
	},

	"rangoEdadCaptacion":{
	    "title":"Rango de edad",
	    "enum":["0 a 3",
		    "4 a 6",
		    "7 a 12",
		    "13 a 17",
		    "18 a 24",
		    "25 a 31",
		    "32 a 38",
		    "39 a 45",
		    "46 a 52",
		    "53 a 59",
		    "60 a 69",
		    "70 a 79",
		    "80 en adelante"]
	},

	"trayectoSalida":{
	    "title":"Trayecto/Salida",
	    "type":"string"
	},
	"intermedio":{
	    "title":"Intermedio",
	    "type":"string"
	},
	"destino":{
	    "title":"Destino",
	    "type":"string"
	},
	
	"casoRelacionado":{
	    "title":"Caso relacionado",
	    "type":"string"
	},

	"casoRelacionadoRelacion":{
	    "title":"Relación",
	    "type":"string"
	},

	"consecuenciasEnLaVictima":{
	    "title":"Consecuencias en la víctima",
	    "type":"string",
	    "enum":[
		"Contagio por enfermedades",
		"Síntomas a consecuencias de maltrato físico",
		"Embarazo no deseado",
		"Complicaciones por embarazo o aborto",
		"Consecuencias a partir de las privacioens físicas, sensoriales y de alimentos",
		"Consecuencias orgánicas a partir de la violencia física(lastimaduras en sus órganos sexuales)",
		"Trastornos de alimentación por las privaciones a las que estuvieron sometidos",
		"Depresión/Tristeza",
		"Sentimientos de desesperación, culpa y vergüenza",
		"Pensamientos suicidas",
		"Agotamiento y problemas de sueño",
		"Síntomas de estrés postraumático (recuerdos, pesadillas, ataques de ansiedad, irritabilidad)",
		"Disosiación o retraimiento emocional",
		"Incapacidad de concentrarse/capacidad limitada de organizar y estructurar, así como confusión del sentido del tiempo",
		"Pérdida de confianza / Pobre imagen de sí mismo (creer que no valen nada)",
		"Baja autoestima / sentimientos de odio hacia sí mismo(a)",
		"Se perciben como mercancías vendibles generando un sentimiento de degradación",
		"Sentimientos confusos sobre el amor y el sexo",
		"Ira o enojo",
		"Desconfianza en otras personas",
		"Adopción o desarrollo de conductas antisociales",
		"Dificultad para relacionarse con los demás (incluye familia y en la escuela)",
		"Adicción a las drogas y el alcohol o las sustancias a las que estuvieron expuestos",
		"La represión de la ira (ataques de ira contra otros o contra si mismos)",
		"Agresividad y enojo con los que los rodean",
		"Relaciones de dependencia con las personas abusadoras",
		"Preocupación por el futuro de su vida",
		"Preocupación por el estigma social y lo que pueda pensar su familia y comunidad",
		"Dificultad para relacionarse de forma sana con otras personas (consecuencia del proceso de subjetivación)",
		"Conductas sexualizadas, desarrollo psicosexual alterado y dificulta su adaptación (por exposición)",
		"Tendencia a huir de entornos protectores",
		"Dificultad de adaptación a entornos de protección",
	    ]
	},

	"condicionesDeVulnerabilidadDeLaVictima":{
	    "title":"Condiciones de vulnerabilidad de la víctima",
	    "enum":[
		"Edad",
		"Discapacidad",
		"Victimización",
		"Migración y desplazamiento interno",
		"Pobreza",
		"Género",
		"Pertenencia a minorías",
		"Privación de la libertad",
		"Pertenencia a comunidades indígenas"
	    ]
	},

	"mediosComisivos":{
	    "title":"Medios comisivos del delito",
	    "type":"string",
	    "enum":[
		"Engaño",
		"Violencia, amenaza o cualquier medio de intimidación o coerción",
		"Abuso de poder o situación",
		"Aprovechamiento de una situación de vulnerabilidad",
		"Amenaza de denuncia ante autoridades respecto a situación",
		"Utilización de la fuerza o la amenza de la fuerza de unaorganización criminal",
		"Enamoramiento",
		"Uso de sustancias",
		"Aislamiento social",
		"Estigma social",
		"Deudas adquiridas o control de dinero",
		"Retención de documentos",
		"Concesión o recepción de pagos o beneficios para obtener el consentimiento de una persona"]
	},

	///////////////////////////
	
	"asesoriaJuridica":{
	    
	    "title": "Asesoría jurídica",
	    "type":"boolean"
	},

	"atencionPsicologica":{
	    
	    "title": "Atención psicológica",
	    "type":"boolean"
	},


	"canalizacionGobierno":{
	    
	    "title":"Canalización a instancia gubernamental",
	    "type":"boolean"
	},
	"canalizacionGobiernoInfo":{
	    "title":"Instancia gubernamental",
	    "type":"string"
	},
	
	"canalizacionOrganizacionCivil":{
	    
	    "title": "Canalización a organización Civil",
	    "type":"boolean"
	},
	"canalizacionOrganizacionCivilInfo":{
	    "title":"Nombre de la organización civil",
	    "type":"string"
	},
	"acompanamientoFiscalia":{
	    
	    "title":"Acompañamiento a la fiscalía correspondiente",
	    "type":"boolean"
	},
	"acompanamientoFiscaliaInfo":{
	    "title":"Nombre de la instancia correspondiente",
	    "type":"string"
	},

	"derivacionRecompensa":{
	    "title":"Derivación a recompensa extinción de dominio",
	    "type":"boolean"
	},
	"derivacionRecompensaInfo":{
	    "title":"Folio de derivación",
	    "type":"string"
	},

	"envioOficio":{
	    "title":"Envío de oficio a autoridad",
	    "type":"boolean"
	},
	"envioOficioInfo":{
	    "title":"Número de oficio",
	    "type":"string"
	},

	"instanciaDeCanalizacion":{
	    "title":"Instancia de canalización",
	    "type":"string"
	},

	"respuestaDeCanalizacion":{
	    "title":"Respuesta",
	    "type":"boolean"
	},
	
	"apoyoAlbergue":{
	    
	    "title":"Apoyo de derivación a albergue",
	    "type":"boolean"
	},
	"apoyoAlbergueInfo":{
	    "title":"Nombre del albergue",
	    "type":"string"
	},

	"noCanalizado":{
	    
	    "title":"No canalizado",
	    "type":"boolean"
	},
	"noCanalizadoInfo":{
	    "title":"Motivo",
	    "type":"string"
	},

	////////////////

	
	"autoridadDenuncia":{
	    "title":"Denuncia",
	    "type":"boolean"
	},
	
	"autoridadDenunciaInfo":{
	    "type":"string",
	    "title":"Número de denuncia"
	},
	"autoridadFecha":{
	    "title":"Fecha de denuncia",
	    "type":"boolean"
	},
	
	"autoridadFechaInfo":{
	    "type":"string",
	    "title":"Indicar fecha"
	    
	},
	"autoridadLugar":{
	    "title":"Lugar de denuncia",
	    "type":"boolean"
	},
	
	"autoridadLugarInfo":{
	    "type":"string",
	    "title":"Lugar donde se efectúa"
	},
	"alertaAmber":{
	    "title":"Reporte por ausencia: Alerta Amber",
	    "type":"boolean"
	},
	
	"alertaAmberInfo":{
	    "type":"string",
	    "title":"Datos del reporte"
	},
	"alertaAlba":{
	    "title":"Reporte por ausencia: Codigo Alba",
	    "type":"boolean"
	},
	
	"alertaAlbaInfo":{
	    "type":"string",
	    "title":"Datos del reporte"
	},
	"reporteProduraduria":{
	    "title":"Reporte por ausencia: Reporte ante la procuraduria",
	    "type":"boolean"
	},
	"reporteProduraduriaInfo":{
	    "type":"string",
	    "title":"Datos del reporte"
	},

	///////



	"investigacion":{
	    "title":"Investigación",
	    "type":"boolean"
	},
	"investigacionInfo":{
	    "title":"Información de la investigación",
	    "type":"string"
	},
	// "averiguacionPrevia":{
	//     "title":"Averiguación previa",
	//     "type":"boolean"
	// },
	// "averiguacionPreviaInfo":{
	//     "title":"Observaciones",
	//     "type":"string"
	// },
	"diligencia":{
	    "title":"Diligencia",
	    "type":"boolean"
	},
	"diligenciaInfo":{
	    "title":"Datos de diligencia",
	    "type":"string"
	},
	"sentencia":{
	    "title":"Sentencia",
	    "type":"boolean"
	},
	"sentenciaInfo":{
	    "title":"Datos de la sentencia",
	    "type":"string"
	},
	"personasRescatadas":{
	    "title":"Personas rescatadas",
	    "type":"boolean"
	},
	"personasRescatadasInfo":{
	    "title":"Número de personas rescatadas",
	    "type":"string"
	},

	"clasificacionTdp":{
	    "title":"Clasificación del caso",
	    "type":"string",
	    "enum":["Trata de personas",
		    " Explotación",
		    " No aplica",
		    " Riesgo",
		    " Otros delitos"]
	}
	
    },

    
    "dependencies":{
	"otroTipoDeFamiliar":["tipoDeFamiliar"],
	"mediosCaptacion":["actividadesIdentificadas"],
	"rangoEdadCaptacion":["actividadesIdentificadas"],
	"formaCaptacion":["actividadesIdentificadas"],
	"intermedio":["actividadesIdentificadas"],
	"trayectoSalida":["actividadesIdentificadas"],
	"destino":["actividadesIdentificadas"] 
    }
}


var validationTrataOptions = {
    "hideInitValidationError":false,
    "focus":"hechosDescripcion",
    "fields":{

	"rangoEdadCaptacion":{
	    "sort":false  
	},
	
	"consecuenciasEnLaVictima":{
	    "type":"select",
	    "removeDefaultNone":true,
	    
	    "multiselect": {
		"enableFiltering": true,
		"numberDisplayed": 3,
		enableCaseInsensitiveFiltering: true,
		"nonSelectedText":"Selecciona uno..."
	    },
	    "multiple": true,
	    "hideInitValidationError": true
	},

	"condicionesDeVulnerabilidadDeLaVictima":{
	    "type":"select",
	    "removeDefaultNone":true,
	    
	    "multiselect": {
		"enableFiltering": true,
		"numberDisplayed": 3,
		enableCaseInsensitiveFiltering: true,
		"nonSelectedText":"Selecciona uno..."

	    },
	    "multiple": true,
	    "hideInitValidationError": true
	},
	
	"tipoDeFamiliar":{
	    "label":"Tipo de familiar"
	},
	"otroTipoDeFamiliar":{
	    "label":"Otro (Tipo de familiar)",
	    "dependencies":{
		"tipoDeFamiliar": ["Otro"]
	    }
	},
	
	"actividadesIdentificadas":{
	    "label":"Actividades identificadas",
	    "removeDefaultNone":true,
	    
	    "multiselect": {
		"enableFiltering": false,
		"numberDisplayed": 3,
		"nonSelectedText":"Selecciona uno..."

	    },
	    "multiple": true,
	    "hideInitValidationError": true
	},

	"rangosEdadProbableResponsable":{
	    "sort":false
	},
	
	"rangoEdad":{
	    "type":"select",
	    "sort":false
	},
	"mediosCaptacion":{
	    "dependencies":{
		"actividadesIdentificadas":"Captación"
	    }
	},
	"formaCaptacion":{
	    "dependencies":{
		"actividadesIdentificadas":"Captación"

	    }
	},
	"rangoEdad":{
	    "dependencies":{
		"actividadesIdentificadas":"Captación"

	    }
	},
	// "accionesDelConsejo":{
	//     "type":"table",
	//     "toolbarSticky":true,
	//     "actionbar":{
	// 	"showLabels": true,
	// 	"actions":[{
	// 	    "label":"Acción",
	// 	    "action":"custom",
	// 	    "click": function(){console.log(this);alert("Acabas de enviar un mail!");}
	// 	}]
	//     },
	//     "toolbar":{
	// 	"actions":[{
	// 	    "action":"add",
	// 	    "label":"Agregar acción"
	// 	}]
        //     }
	// },

	// "accionesDelLlamante":{
	//     "type":"table",
	//     "toolbarSticky":true,
	//     "actionbar":{
	// 	"actions":[{
	// 	    "label":"Acción",
	// 	    "action":"custom",
	// 	    "click": function(){console.log(this);alert("Acabas de enviar un mail!");}
	// 	}]
	//     },
	//     "toolbar":{
	// 	"actions":[{
	// 	    "action":"add",
	// 	    "label":"Agregar acción"
	// 	}]
        //     }
	// },

	// "accionesDeLaAutoridad":{
	//     "type":"table",
	//     "toolbarSticky":true,
	//     "actionbar":{
	// 	"actions":[{
	// 	    "label":"Acción",
	// 	    "action":"custom",
	// 	    "click": function(){console.log(this);alert("Acabas de enviar un mail!");}
	// 	}]
	//     },
	//     "toolbar":{
	// 	"actions":[{
	// 	    "action":"add",
	// 	    "label":"Agregar acción"
	// 	}]
        //     }
	// },

	"observacionesValidador":{
	    "type":"textarea"
	},

	"mediosComisivos":{
	    "removeDefaultNone":true,
	    "type":"select",
	    "multiselect": {
		"enableFiltering": true,
		"numberDisplayed": 3
	    },
	    "multiple": true,
	    "hideInitValidationError": true
	},

	"trayectoSalida":{
	    "dependencies":{
		"actividadesIdentificadas":"Transferencia"
	    }
	},
	"intermedio":{
	    "dependencies":{
		"actividadesIdentificadas":"Transferencia"
	    }
	},
	"destino":{
	    "dependencies":{
		"actividadesIdentificadas":"Transferencia"
	    }
	},

	"autoridadFechaInfo":{
	    "type":"datetime",
	    "picker":{
		locale:"es"
	    }
	},

	"clasificacionTdp":{
	    "noneLabel":"Selecciona uno..."
	}
	
	
    },
    "form":{
	"buttons":{
	    "submit":{
		"styles":"pull-right btn-primary btn-lg",
		"label":"Guardar validación", 
		"click": function(e){
		    var value = this.getValue();
	    	    var stringval = JSON.stringify(value, null, "  ");
		    $.ajax({
			url: ajaxSubmit,
			method: "post",
			data: {
			    reportValidation: stringval,
			    reportId: selectedReport,
			    action:"addValidationAction"
			},
			success: function(data){
			    var _data = data;
			    _data = JSON.parse(data);
			    console.log(_data.reportValidation);
			    reportTrataForm.setValue(_data.reportValidation);
			    $.notify(
				_data.success,{
				    "className": "success",
				    "globalPosition": "bottom right"
				});
	    		} 
		    });
		}
	    }
	},
	"hideInitValidationError":false 
    }
    
}

$(document).ready(function(){
    // $("#validationTrataForm").alpaca({
    // 	"schema": validationTrataSchema,
    // 	"option": validationOptions,
    // 	"view": "bootstrap-edit"
    // });    
});


