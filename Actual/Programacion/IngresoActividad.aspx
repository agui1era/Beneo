<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="IngresoActividad.aspx.cs" Inherits="WEB.IngresoActividad" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <%--<link rel="stylesheet" href="../AdminLte/plugins/select2/css/select2.min.css" />--%>

    <script type="text/javascript">
        var nowDate = new Date();
        var today = new Date(nowDate.getFullYear(), nowDate.getMonth(), nowDate.getDate(), 0, 0, 0, 0);
        $(function() {
            $("#<%= txtRangoFecha.ClientID %>").daterangepicker({
                "locale": {
                    "format": "DD/MM/YYYY",
                    "separator": " - ",
                    "applyLabel": "Aceptar",
                    "cancelLabel": "Cancelar",
                    "fromLabel": "From",
                    "toLabel": "To",
                    "customRangeLabel": "Custom",
                    "daysOfWeek": [
                        "Do",
                        "Lu",
                        "Ma",
                        "Mi",
                        "Ju",
                        "Vi",
                        "Sa"
                    ],
                    "monthNames": [
                        "Enero",
                        "Febrero",
                        "Marzo",
                        "Abril",
                        "Mayo",
                        "Junio",
                        "Julio",
                        "Agosto",
                        "Septiembre",
                        "Octubre",
                        "Noviembre",
                        "Diciembre"
                    ],
                    "firstDay": 1,
                    "mindate": today
                }
            })
            $('.select2').select2()            
        })


    </script>
    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Programación</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="../Inicial/Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item"><a href="ProgramacionCons.aspx">Consulta de programación</a></li>
            <li class="breadcrumb-item"><asp:LinkButton ID="lnkVolverProgramacion" runat="server" OnClick="lnkVolverProgramacion_Click">Programación</asp:LinkButton></li>
            <li class="breadcrumb-item active">Ingreso de Actividad</li>
        </ol>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="card card-default" data-select2-id="42">
        <div class="card-header">
            <h3 class="card-title">Ingreso de Actividad</h3>

            <div class="card-tools">
                <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
            </div>
        </div>
        <!-- /.card-header -->
        <!-- form start -->
        <div class="card-body">
            <div class="row">
                <div class="col-12">

                    <div class="row">
                        <div class="form-group col-md-5 col-sm-5">
                            <label for="txtActividad">Actividad</label>
                            <asp:DropDownList ID="ddlActividad" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Nombre" DataTextField="Nombre"></asp:DropDownList>
                        </div>
                        <div class="form-group col-md-1 col-sm-1">
                            <label for="txtActividad">Nueva Actividad</label>
                            <button type="button" class="btn btn-default" data-toggle="modal" data-target="#modal-default">Nuevo </button>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                            <label for="ddlPrioridad">Prioridad</label>
                            <asp:DropDownList ID="ddlPrioridad" runat="server" CssClass="form-control select2" DataValueField="Id" DataTextField="Prioridad"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-md-6 col-sm-6">
                            <label for="txtRangoFecha">Semana</label>
                            <asp:TextBox ID="txtRangoFecha" runat="server" class="form-control" placeholder="Semana"></asp:TextBox>
                        </div>

                        <div class="form-group col-md-6 col-sm-6">
                            <label for="lstTratamiento">Tratamiento</label>
                            <asp:ListBox ID="lstTratamiento" CssClass="form-control select2" DataValueField="Id" DataTextField="Id" runat="server" SelectionMode="Multiple"></asp:ListBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-md-12 col-sm-12">
                            <label for="lstDia">Días</label>
                            <asp:ListBox ID="lstDia" CssClass="form-control select2" DataValueField="Id" DataTextField="Dia" runat="server" SelectionMode="Multiple"></asp:ListBox>                            
                        </div>
                    </div>

                    <div class="row">
                        <div class="form-group col-md-12 col-sm-12">
                            <label for="txtObservaciones">Observaciones</label>
                            <asp:TextBox ID="txtObservaciones" runat="server" class="form-control" placeholder="Observaciones" autocomplete="off"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="form-group col-md-12 col-sm-12" id="grpArchivos" runat="server">
                            <label>Archivos</label>

                            <div class="btn-group">
                                <asp:Button ID="btnArchivo" runat="server" class="btn btn-info" Text="Archivos" OnClick="btnArchivo_Click" />
                                <button type="button" class="btn btn-info dropdown-toggle dropdown-icon" data-toggle="dropdown">
                                </button>

                                <div class="dropdown-menu" id="menuVer" runat="server">
                                </div>
                            </div>
                        </div>
                    </div>                    
                </div>
            </div>

            
                <ul class="nav nav-tabs" id="custom-content-below-tab" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="custom-content-below-home-tab" data-toggle="pill" href="#custom-content-below-home" role="tab" aria-controls="custom-content-below-home" aria-selected="true">Productos</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="custom-content-below-profile-tab" data-toggle="pill" href="#custom-content-below-profile" role="tab" aria-controls="custom-content-below-profile" aria-selected="false">Herramientas</a>
                    </li>
                </ul>

                <div class="tab-content" id="custom-content-bellow-tabContent">
                    <div class="tab-pane fade active show" id="custom-content-below-home" role="tabpanel" aria-labelledby="custom-content-below-home-tab">
                        <div class="row">
                            <div class="col-md-12 col-sm-12">


                        <asp:GridView ID="dtgProductos" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" DataKeyNames="Id" EmptyDataText="No existen productos" OnRowDataBound="dtgProductos_RowDataBound" >
                                <Columns>
                                    <asp:CheckBoxField DataField="Sel" HeaderText="Seleccionar">
                                    <ItemStyle HorizontalAlign="Center" />
                                    </asp:CheckBoxField>
                                    <asp:BoundField DataField="Codigo" HeaderText="Código" />
                                    <asp:BoundField DataField="Descripcion" HeaderText="Producto" />
                                    <asp:BoundField DataField="Categoria" HeaderText="Categoría" />
                                    <asp:BoundField DataField="Sigla" HeaderText="UM" />
                                    <asp:BoundField DataField="Cantidad" HeaderText="Stock" DataFormatString="{0:#,##0.##}">
                                    <ItemStyle HorizontalAlign="Right" />
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                                </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="custom-content-below-profile" role="tabpanel" aria-labelledby="custom-content-below-profile-tab">
                         
                                <asp:GridView ID="dtgHerramientas" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" DataKeyNames="Id" EmptyDataText="No existen herramientas" OnRowDataBound="dtgHerramientas_RowDataBound">
                                <Columns>
                                    <asp:CheckBoxField DataField="Sel" HeaderText="Seleccionar">
                                    <ItemStyle HorizontalAlign="Center" />
                                    </asp:CheckBoxField>
                                    <asp:BoundField DataField="Codigo" HeaderText="Código" />
                                    <asp:BoundField DataField="Nombre" HeaderText="Herramienta" />
                                    <asp:BoundField DataField="Categoria" HeaderText="Categoría" />
                                    <asp:BoundField DataField="Cantidad" HeaderText="Stock" DataFormatString="{0:#,##0.##}">
                                    <ItemStyle HorizontalAlign="Right" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Bodega" HeaderText="Bodega" />
                                    <asp:TemplateField HeaderText="Descontar">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtDescontar" runat="server" class="form-control"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                    </div>
                </div>

        </div>
        <!-- /.card-body -->
        
        <div class="card-footer">
            <asp:Button ID="btnGuardar" runat="server" class="btn btn-primary" Text="Guardar" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnEliminar" runat="server" class="btn btn-danger" Text="Eliminar" OnClick="btnEliminar_Click" />
            <asp:Button ID="btnNuevo" runat="server" class="btn btn-info" Text="Nuevo" OnClick="btnNuevo_Click" />
            <asp:Button ID="btnCancelar" runat="server" class="btn btn-warning" Text="Cancelar" OnClick="btnCancelar_Click" />
        </div>
            
    </div>

    <div class="modal fade" id="modal-default" aria-hidden="true" style="display: none;">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Agregar nueva actividad</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <asp:TextBox ID="txtNuevaActividad" runat="server" class="form-control" placeholder="Actividad"></asp:TextBox>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                    <asp:Button ID="btnNuevaActividad" runat="server" CssClas="btn btn-primary" Text="Guardar" OnClick="btnNuevaActividad_Click" />
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade" id="modal-archivo" aria-hidden="true" style="display: none;">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><%= "Archivos Programación \""  %>  <%--</h4> + txtNombreArchivo.Text + "\"" %>  </h4>--%>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnGuardarDoc" EventName="Click" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="row">
                                <div class="form-group col-md-6 col-sm-6">
                                    <label for="txtNombreArchivo">Nombre</label>
                                    <asp:TextBox ID="txtNombreArchivo" runat="server" CssClass="form-control" placeholder="Nombre" autocomplete="off"></asp:TextBox>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <label for="txtNombreArchivo">Archivo</label>
                                    <div class="input-group">
                                        <div class="custom-file">
                                            <%--<asp:FileUpload ID="fluArchivo" runat="server" ViewStateMode="Enabled" />--%>
                                            <asp:AsyncFileUpload ID="fluArchivo" runat="server" OnUploadedComplete="fluArchivo_UploadedComplete" PersistFile="True" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-md-6 col-sm-6">
                                    <div class="custom-control custom-switch">  
                                        <input type="checkbox" class="form-check-input" id="chkObligatorio" runat="server" />                                     
                                        <%--<input type="checkbox" checked="checked" data-toggle="toggle" data-on="Ready" data-off="Not Ready" data-onstyle="success" data-offstyle="danger">--%>
                                        <label class="form-check-label" for="chkObligatorio">Obligatorio</label>
                                    </div>
                                </div>
                            </div>
                            <div class="row">

                                <div class="form-group col-md-12 col-sm-12">
                                    <asp:GridView ID="dtgDocs" CssClass="table table-bordered table-striped" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" EmptyDataText="No hay documentos" Width="100%" OnRowCommand="dtgDocs_RowCommand">
                                        <Columns>
                                            
                                            <asp:BoundField DataField="Archivo" HeaderText="Nombre" />
                                            <asp:BoundField DataField="Descripcion" HeaderText="Archivo" />
                                            <asp:CheckBoxField DataField="Obligatorio" HeaderText="Obligatorio" />

                                            <asp:TemplateField>
                                                <ItemTemplate>
                                                    <asp:Button ID="btnEliminar" class="btn btn-danger" runat="server" Text="Eliminar" CommandName="Eliminar" CommandArgument='<%#Eval("Id") %>'></asp:Button>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <PagerStyle CssClass="pagination pagination-sm float-right" />
                                    </asp:GridView>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="modal-footer justify-content-between">
                    <%--<button type="button" class="btn btn-default" data-dismiss="modal" >Cerrar</button>--%>
                    <asp:Button ID="btnCerrarDoc" runat="server" CssClas="btn btn-default" Text="Cerrar" OnClick="btnCerrarDoc_Click" />
                    <asp:Button ID="btnGuardarDoc" runat="server" CssClas="btn btn-primary" Text="Guardar" OnClick="btnGuardarDoc_Click" />
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
