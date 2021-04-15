<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="Ensayo.aspx.cs" Inherits="WEB.Ensayo" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(function () {

            $('.select2').select2()

            $("#<%= dtgEnsayos.ClientID %>").DataTable({
              "responsive": true,
              "autoWidth": false
            });
        })
    </script>
       <div class="col-sm-6">
        <h1 class="m-0 text-dark">Ensayo</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="../Inicial/Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Ensayo</li>
        </ol>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- general form elements -->

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="card card-default">
        <div class="card-header">
            <h3 class="card-title">Actualización de Ensayos</h3>
        </div>
        <!-- /.card-header -->
        <!-- form start -->
        <div class="card-body">
            <div class="row">

                <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlTemporada">Temporada</label>
                    <asp:DropDownList ID="ddlTemporada" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Nombre" AutoPostBack="true" OnSelectedIndexChanged="ddlTemporada_SelectedIndexChanged"></asp:DropDownList>
                </div>

                <div class="form-group col-md-6 col-sm-6">
                    <label for="lstLugar">Lugar</label>
                    <asp:DropDownList ID="ddlLugar" CssClass="form-control select2" DataValueField="Id" DataTextField="Nombre" runat="server" ></asp:DropDownList>
                </div>

            </div>
            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtCodigo">Código Ensayo</label>
                    <asp:TextBox ID="txtCodigo" runat="server" class="form-control" placeholder="Codigo" autocomplete="off"></asp:TextBox>
                </div>
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtNombre">Nombre Ensayo</label>
                    <asp:TextBox ID="txtNombre" runat="server" class="form-control" placeholder="Nombre" autocomplete="off"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlEspecie">Especie</label>
                    <asp:DropDownList ID="ddlEspecie" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Nombre"></asp:DropDownList>
                </div>  
                <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlResponsable">Responsable</label>
                    <asp:DropDownList ID="ddlResponsable" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="usu_usuario"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtCantTratamiento">Cant. Tratamiento</label>
                    <asp:TextBox ID="txtCantTratamiento" runat="server" CssClass="form-control" placeholder="Cantidad Tratamiento" TextMode="Number" autocomplete="off"></asp:TextBox>
                </div>
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtCantRepeticion">Cant. Repetición</label>
                    <asp:TextBox ID="txtCantRepeticion" runat="server" CssClass="form-control" placeholder="Cantidad Repeticion" TextMode="Number" autocomplete="off"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtCantCosechas">Cant. Cosechas</label>
                    <asp:TextBox ID="txtCantCosechas" runat="server" CssClass="form-control" placeholder="Cantidad Cosechas" TextMode="Number" autocomplete="off"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-6 col-sm-6" id="grpArchivos" runat="server">
                    <label for="txtArchivos">Archivos</label>

                    <div class="btn-group">
                        <asp:Button ID="btnArchivo" runat="server" class="btn btn-info" Text="Button" OnClick="btnArchivo_Click" />
                        <button type="button" class="btn btn-info dropdown-toggle dropdown-icon" data-toggle="dropdown">
                        </button>

                        <div class="dropdown-menu" id="menuVer" runat="server">
                        </div>
                    </div>
                </div>

                <div class="form-group col-md-6 col-sm-6" id="grpFechas" runat="server">
                    <label for="txtFechas">Fechas de siembra</label>
                    <asp:Button ID="btnFechaCosecha" CssClass="btn btn-block btn-primary" runat="server" Text="" OnClick="btnFechaCosecha_Click" />
               
                </div>
            </div>
            <div class="row">
                <div class="form-group">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="chkActivo" runat="server" />
                        <%--<asp:CheckBox ID="chkActivo" runat="server" class="form-check-input" />--%>
                        <label for="chkActivo" class="form-check-label">Activo</label>
                    </div>
                </div>
            </div>
        </div>
        <!-- /.card-body -->
        <div class="card-footer">
        <asp:Button ID="btnGuardar" runat="server" class="btn btn-primary" Text="Guardar" OnClick="btnGuardar_Click" />
        <asp:Button ID="btnEliminar" runat="server" class="btn btn-danger" Text="Eliminar" OnClick="btnEliminar_Click" />
        <asp:Button ID="btnClonar" runat="server" class="btn btn-warning" Text="Clonar" OnClick="btnClonar_Click" />
        <asp:Button ID="btnNuevo" runat="server" class="btn btn-info" Text="Nuevo" OnClick="btnNuevo_Click" />
        </div>
    </div>
    <div class="card">
        <div class="card-header">
            <h3 class="card-title">Consulta de Ensayos</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <asp:GridView ID="dtgEnsayos" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnPageIndexChanging="dtgEnsayos_PageIndexChanging" OnRowCommand="dtgEnsayo_RowCommand" OnDataBound="dtgEnsayos_DataBound" OnRowCreated="dtgEnsayos_RowCreated">
                <Columns>
                    <%--<asp:BoundField HeaderText="#" DataField="Numero">
                        <ItemStyle Width="20px" />
                    </asp:BoundField>--%>
                    <asp:BoundField DataField="Id" HeaderText="Id" Visible="false" />
                    <asp:BoundField DataField="Codigo" HeaderText="Ensayo" />
                    <asp:BoundField DataField="Especie" HeaderText="Especie" />
                    <asp:BoundField DataField="CodLugar" HeaderText="Lugar" />
                    <asp:BoundField DataField="nombre_empleado" HeaderText="Responsable" />
                    <asp:BoundField DataField="CantTratamiento" HeaderText="Cant.Tratamiento" />
                    <asp:BoundField DataField="CantRepeticion" HeaderText="Cant.Repeticion" />
                    <asp:CheckBoxField DataField="Activo" HeaderText="Activo" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnModificar" class="btn btn-success" runat="server" Text="Modificar" CommandName="Modificar" CommandArgument='<%#Eval("Id") %>'></asp:Button>
                        </ItemTemplate>
                    </asp:TemplateField>                    
                    <%--<asp:ButtonField ButtonType="Button" HeaderText="Modificar" Text="modificar">
                        <ControlStyle CssClass="btn btn-primary" />
                    </asp:ButtonField>--%>
                </Columns>
                <PagerStyle CssClass="pagination pagination-sm float-right" />
            </asp:GridView>
        </div>
        <!-- /.card-body -->
    </div>
    <!-- /.card -->


    <div class="modal fade" id="modal-default" aria-hidden="true" style="display: none;">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><%= "Archivos del ensayo \"" + txtCodigo.Text + "\"" %>  </h4>
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
                                <div class="form-group">
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input" id="chkObligatorio" runat="server" />
                                        <%--<asp:CheckBox ID="chkActivo" runat="server" class="form-check-input" />--%>
                                        <label for="chkObligatorio" class="form-check-label">Obligatorio al terminar la tarea</label>
                                    </div>
                                </div>
                            </div>
                            <div class="row">

                                <div class="form-group col-md-12 col-sm-12">
                                    <asp:GridView ID="dtgDocs" CssClass="table table-bordered table-striped" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" EmptyDataText="No hay documentos" Width="100%" OnRowCommand="dtgDocs_RowCommand">
                                        <Columns>
                                            <%--<asp:BoundField HeaderText="#" DataField="Numero">
                        <ItemStyle Width="20px" />
                    </asp:BoundField>--%>
                                            <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                                            <asp:BoundField DataField="NombreArchivo" HeaderText="Archivo" />
                                            <asp:CheckBoxField DataField="Obligatorio" HeaderText ="Obligatorio" />

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
    <%--<!-- Modal Clonar Ensayo -->
    <div class="modal fade" id="modal-clonar" aria-hidden="true" style="display: none;">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Clonar Ensayo</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="form-group col-md-6 col-sm-6">
                            <label for="txtCodigoClonar">Código Ensayo</label>
                            <asp:TextBox ID="txtCodigoClonar" runat="server" class="form-control" placeholder="Codigo" autocomplete="off"></asp:TextBox>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                            <label for="txtNombreClonar">Nombre Ensayo</label>
                            <asp:TextBox ID="txtNombreClonar" runat="server" class="form-control" placeholder="Nombre" autocomplete="off"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-md-6 col-sm-6" id="Div1" runat="server">
                            <label for="txtFechasClonar">Fechas de siembra</label>
                            <asp:Button ID="btnFechasCosechasClonar" CssClass="btn btn-block btn-primary" runat="server" Text="Fechas Siembra" OnClick="btnFechasCosechasClonar_Click" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnModalClonar" runat="server" Text="Clonar" CssClass="btn btn-primary" OnClick="btnModalClonar_Click" />
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>    --%>
</asp:Content>
