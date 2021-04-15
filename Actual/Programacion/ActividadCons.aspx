<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="ActividadCons.aspx.cs" Inherits="WEB.ActividadCons" EnableEventValidation="false" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(function () {
            $("#<%= txtFechaDesde.ClientID %>").inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })
            $("#<%= txtFechaHasta.ClientID %>").inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })
            $("#<%= txtFechaEjecucion.ClientID %>").inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })
            <%--$("#<%= txtFechaReprog.ClientID %>").inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })--%>

            $("#<%= dtgPrincipal.ClientID %>").DataTable({
              "responsive": true,
              "autoWidth": false
            });
        })
    </script>

    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Registro Actividad</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Registro Actividad</li>
        </ol>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="card card-default">
        <div class="card-header">
            <h3 class="card-title">Filtros</h3>
        </div>
        <!-- /.card-header -->
        <!-- form start -->
        <div class="card-body row">
            
            <div class="form-group col-md-6 col-sm-6">
                <label>Fecha Desde</label>

                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text">
                            <i class="far fa-calendar-alt"></i>
                        </span>
                    </div>
                    <asp:TextBox ID="txtFechaDesde" CssClass="form-control" runat="server" data-inputmask-alias="datetime" data-inputmask-inputformat="dd/mm/yyyy" data-mask="datemask" im-insert="false"></asp:TextBox>
                </div>                 
                <!-- /.input group -->
            </div> 
            <div class="form-group col-md-6 col-sm-6">
                <label>Fecha Hasta</label>

                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text">
                            <i class="far fa-calendar-alt"></i>
                        </span>
                    </div>
                    <asp:TextBox ID="txtFechaHasta" CssClass="form-control" runat="server" data-inputmask-alias="datetime" data-inputmask-inputformat="dd/mm/yyyy" data-mask="datemask" im-insert="false"></asp:TextBox>
                </div>                 
                <!-- /.input group -->
            </div>            
        </div>
        <div class="card-body row">
            <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlTemporada">Temporada</label>
                    <asp:DropDownList ID="ddlTemporada" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Nombre" AutoPostBack="True" OnSelectedIndexChanged="ddlTemporada_SelectedIndexChanged"></asp:DropDownList>

                </div>
                <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlLugar">Lugar</label>
                    <asp:DropDownList ID="ddlLugar" runat="server" CssClass="form-control select2" DataValueField="Id" DataTextField="Nombre" AutoPostBack="True" OnSelectedIndexChanged="ddlLugar_SelectedIndexChanged"></asp:DropDownList>
                </div>
        </div>
         <div class="card-body row">
             <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlEnsayo">Ensayo</label>
                    <asp:DropDownList ID="ddlEnsayo" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Codigo"></asp:DropDownList>
                </div>
        </div>
        <!-- /.card-body -->
        <div class="card-footer">
            <asp:Button ID="btnFiltrar" runat="server" class="btn btn-info" Text="Filtrar" OnClick="btnFiltrar_Click" />            
        </div>

    </div>
    <div class="card">
        <div class="card-header">
            <h3 class="card-title">Registro Actividad</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-header">
            <asp:Button ID="btnArchivos" class="btn btn-primary" runat="server" Text="Subir Archivos" OnClick="btnArchivos_Click" ></asp:Button>
            <asp:Button ID="btnFinalizar" class="btn btn-success" runat="server" Text="Finalizar" OnClick="btnFinalizar_Click" ></asp:Button>
            <asp:Button ID="btnCancelar" class="btn btn-danger" runat="server" Text="Cancelar" OnClick="btnCancelar_Click"></asp:Button>
        </div>
        <div class="card-body">            
            <asp:GridView ID="dtgPrincipal" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="Id,FechaDiaTexto" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnPageIndexChanging="dtgPrincipal_PageIndexChanging" OnSorting="dtgPrincipal_Sorting" OnRowDataBound="dtgPrincipal_RowDataBound" OnDataBound="dtgPrincipal_DataBound" OnRowCommand="dtgPrincipal_RowCommand" OnRowCreated="dtgPrincipal_RowCreated">
                <Columns>
                    <asp:CheckBoxField DataField="Sel"  />
                    <asp:BoundField DataField="FechaDia" HeaderText="Fecha Actividad" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="Dia" HeaderText="Dia" />
                    <asp:BoundField DataField="Actividad" HeaderText="Actividad" />
                    <asp:BoundField DataField="Temporada" HeaderText="Temporada" />
                    <asp:BoundField DataField="Ensayo" HeaderText="Ensayo" />
                    <asp:BoundField DataField="Lugar" HeaderText="Lugar" />
                    <asp:BoundField DataField="dds" HeaderText="DDS" />
                    <asp:BoundField DataField="Responsable" HeaderText="Responsable" />                    
                    <asp:BoundField DataField="Prioridad" HeaderText="Prioridad" />                    
                                  
                </Columns>
                <PagerStyle CssClass="pagination pagination-sm float-right" />
            </asp:GridView>
        </div>
        <!-- /.card-body -->
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <!-- Modal Cancelar Actividad -->
        <div class="modal" id="CancelarRegistroActividad" tabindex="-1" role="dialog" aria-labelledby="CancelarRegistroActividadLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Cancelar Actividad</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body"> 

                        <div class="row">
                            <div class="form-group col-md-12 col-sm-12">
                                <label for="ddlMotivo">Motivo</label>
                                <asp:DropDownList ID="ddlMotivo" runat="server" CssClass="form-control select2" DataValueField="Id" DataTextField="Motivo"></asp:DropDownList>
                            </div>
                        </div>                                            
                        <div class="row">
                            <div class="form-group col-md-12 col-sm-12">
                                <label for="txtObservacion">Observación</label>
                                <asp:TextBox ID="txtObservacion" runat="server" class="form-control" placeholder="Observacion" autocomplete="off"></asp:TextBox>
                            </div>
                        </div>
                        <%--<div class="row">
                            <div class="form-group col-md-2 col-sm-2">
                                <div class="form-check">
                                    <asp:CheckBox ID="chkReprogramar" runat="server" CssClass="form-check-input" AutoPostBack="true" OnCheckedChanged="chkReprogramar_CheckedChanged" />
                                    <label for="chkReprogramar" class="form-check-label">Reprogramar</label>
                                </div>
                            </div>
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <Triggers><asp:AsyncPostBackTrigger ControlID="chkReprogramar" EventName="CheckedChanged" /></Triggers>
                                <ContentTemplate>
                        <div class="form-group col-md-10 col-sm-10" runat="server"  id="FechaProgra" visible ="false">
                            <label>Fecha Reprogramación</label>

                            <div class="input-group" > 
                                <div class="input-group-prepend">
                                    <span class="input-group-text">
                                        <i class="far fa-calendar-alt"></i>
                                    </span>
                                </div>
                                <asp:TextBox ID="txtFechaReprog" CssClass="form-control" runat="server" data-inputmask-alias="datetime" data-inputmask-inputformat="dd/mm/yyyy" data-mask="datemask" im-insert="false"></asp:TextBox>
                            </div>
                            <!-- /.input group -->
                        </div></ContentTemplate>
                                </asp:UpdatePanel>
                        </div>--%>
                        <%--<div class="form-group" hidden="hidden">
                            <asp:TextBox ID="txtFechaDesdeRep" runat="server" class="form-control" placeholder="Id"></asp:TextBox>
                            <asp:TextBox ID="txtFechaHastaRep" runat="server" class="form-control" placeholder="Id"></asp:TextBox>
                        </div> --%>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnGuardarModalCancelar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnGuardarModalCancelar_Click" />
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Modal Finalizar Actividad -->
        <div class="modal" id="FinalizarRegistroActividad" tabindex="-1" role="dialog" aria-labelledby="FinalizarRegistroActividadLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Finalizar Actividad</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        
                        <asp:TextBox ID="txtIdProgAct" runat="server" CssClass="form-control" visible="false"></asp:TextBox>
                        <asp:TextBox ID="txtFechaTexto" runat="server" CssClass="form-control" visible="false"></asp:TextBox>

                        <div class="row">
                            <div class="form-group col-md-12 col-sm-12">
                                <label for="lstResponsables">Responsables</label>
                                <asp:ListBox ID="lstResponsables" CssClass="form-control select2" DataValueField="Id" DataTextField="nombre_empleado" runat="server" SelectionMode="Multiple"></asp:ListBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="form-group col-md-12 col-sm-12">
                                <label for="lstAuxiliares">Auxiliares</label>
                                <asp:ListBox ID="lstAuxiliares" CssClass="form-control select2" DataValueField="Id" DataTextField="nombre_empleado" runat="server" SelectionMode="Multiple"></asp:ListBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="form-group col-md-12 col-sm-12">
                                <label>Fecha Ejecución</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">
                                            <i class="far fa-calendar-alt"></i>
                                        </span>
                                    </div>
                                    <asp:TextBox ID="txtFechaEjecucion" CssClass="form-control" runat="server" data-inputmask-alias="datetime" data-inputmask-inputformat="dd/mm/yyyy" data-mask="datemask" im-insert="false"></asp:TextBox>
                                </div>
                            </div>               
                        </div>

                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnGuardarModalFinalizar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnGuardarModalFinalizar_Click" />
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                    </div>
                </div>
            </div>
        </div>
    </div>    
    <%--<div class="modal fade" id="modal-archivos" aria-hidden="true" style="display: none;">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><%= "Archivos Programación Actividad" %>  </h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">   
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnGuardarModalDoc" EventName="Click" />--%>
                            <%--<asp:AsyncPostBackTrigger ControlID="dtgDocs" EventName="RowCommand" />--%>
                        <%--</Triggers>                
                        <ContentTemplate>                                            
                            <div class="row">
                                <div class="form-group col-md-12 col-sm-12">
                                    <asp:GridView ID="dtgDocs" CssClass="table table-bordered table-striped" DataKeyNames="Id,FechaTexto,IdProgramacionActividad,IdProgramacionActividadRegistro,Ensayo" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" EmptyDataText="No hay documentos" Width="100%" OnRowDataBound="dtgDocs_RowDataBound" OnSelectedIndexChanged="dtgDocs_OnSelectedIndexChanged" OnRowCommand="dtgDocs_RowCommand">
                                        <Columns>                                            
                                            <asp:BoundField DataField="Archivo" HeaderText="Nombre" />
                                            <asp:BoundField DataField="Descripcion" HeaderText="Archivo" />    
                                             <asp:BoundField DataField="Obligatorio" HeaderText="Obligatorio" />                                                                                
                                            
                                            <asp:TemplateField>
                                                <ItemTemplate>
                                                    <asp:Button ID="btnDescargar" class="btn btn-success" runat="server" Text="Descargar"  CommandName="Descargar" ></asp:Button>
                                                </ItemTemplate>
                                            </asp:TemplateField>                                    
                                        </Columns>
                                        <PagerStyle CssClass="pagination pagination-sm float-right" />
                                    </asp:GridView>
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-md-6 col-sm-6">
                                    <label for="txtNombreArchivo">Nombre</label>
                                    <asp:TextBox ID="txtNombreArchivo" runat="server" CssClass="form-control" placeholder="Nombre" autocomplete="off"></asp:TextBox>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <label for="txtNombreArchivo">Archivo</label>
                                    <div class="input-group">
                                        <div class="custom-file">--%>
                                            <%--<asp:FileUpload ID="fluArchivo" runat="server" ViewStateMode="Enabled" />--%>
                                            <%--<asp:AsyncFileUpload ID="fluArchivo" runat="server" OnUploadedComplete="fluArchivo_UploadedComplete" PersistFile="True" />
                                        </div>
                                    </div>
                                </div>
                            </div> 
                            <div class="row">

                                <div class="form-group col-md-12 col-sm-12">
                                    <asp:GridView ID="dtgDocsSubir" CssClass="table table-bordered table-striped" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" AllowPaging="True" AllowSorting="True" PageSize="20" EmptyDataText="No hay documentos" Width="100%" OnRowCommand="dtgDocsSubir_RowCommand">
                                        <Columns>
                                            
                                            <asp:BoundField DataField="Archivo" HeaderText="Nombre" />
                                            <asp:BoundField DataField="Descripcion" HeaderText="Archivo" />
                                           
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
                    <asp:Button id="btnCerrarModalDoc" runat="server" CssClas="btn btn-primary"  Text="Cerrar" data-dismiss="modal" OnClick="btnCerrarModalDoc_Click" />
                    <asp:Button ID="btnGuardarModalDoc" runat="server" CssClas="btn btn-primary" Text="Guardar" OnClick="btnGuardarModalDoc_Click" />
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>--%>
</asp:Content>
