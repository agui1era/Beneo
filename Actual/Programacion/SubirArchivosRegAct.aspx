<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="SubirArchivosRegAct.aspx.cs" Inherits="WEB.SubirArchivosRegAct" EnableEventValidation="false" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">    

    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Carga de archivos para la actividad seleccionada</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Registro Actividad</li>
            <li class="breadcrumb-item active">Carga de archivos para la actividad seleccionada</li>
        </ol>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Actividad Seleccionada</h3>
            </div>
            <div class="card-body">

         <asp:GridView ID="dtgPrincipal" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="Id,FechaDiaTexto" runat="server" AutoGenerateColumns="False" PageSize="20" > 
                <Columns>
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
    </div>

    <div class="alert alert-danger">
        <strong> Identifique el archivo que desea cargar.</strong>
    </div>
    
    <div class="card">
        <asp:GridView ID="dtgDocs" CssClass="table table-bordered table-striped" DataKeyNames="Id,FechaTexto,IdProgramacionActividad,IdProgramacionActividadRegistro,Ensayo" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" EmptyDataText="No hay documentos" Width="100%" OnRowDataBound="dtgDocs_RowDataBound" OnSelectedIndexChanged="dtgDocs_OnSelectedIndexChanged" OnRowCommand="dtgDocs_RowCommand">
            <Columns>                
                <asp:BoundField DataField="Archivo" HeaderText="Nombre" />
                <asp:BoundField DataField="Descripcion" HeaderText="Archivo" />
                <asp:BoundField DataField="Obligatorio" HeaderText="Obligatorio" />

                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="btnDescargar" class="btn btn-success" runat="server" Text="Descargar" CommandName="Descargar"></asp:Button>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <PagerStyle CssClass="pagination pagination-sm float-right" />
        </asp:GridView>
    </div>
    
    <div class="alert alert-danger">
        <strong> Busque y seleccione el archivo por el cual desea reemplazar al seleccionado.</strong>
    </div>
    
    <div class="card">
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
    <div class="Card">
        <div class="form-group col-md-6 col-sm-6">
            <asp:Button ID="btnGuardarDoc" runat="server" CssClas="btn btn-primary" Text="Guardar" OnClick="btnGuardarDoc_Click" />
            <asp:Button ID="btnCerrarDoc" runat="server" CssClas="btn btn-primary" Text="Cerrar" data-dismiss="modal" OnClick="btnCerrarDoc_Click" />

        </div>
    </div>    
    <div class="card">
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
    
</asp:Content>
