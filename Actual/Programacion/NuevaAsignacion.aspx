<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="NuevaAsignacion.aspx.cs" Inherits="WEB.NuevaAsignacion" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(function () {
            $("#<%= txtFecha.ClientID %>").inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })
        })
    </script>

    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Asignación</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Asignación de Actividades</li>
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
                <label for="ddlTemporada">Temporada</label>
                <asp:DropDownList ID="ddlTemporada" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Nombre" AutoPostBack="True" OnSelectedIndexChanged="ddlTemporada_SelectedIndexChanged"></asp:DropDownList>
            </div>
            <div class="form-group col-md-6 col-sm-6">
                <label>Fecha</label>

                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text">
                            <i class="far fa-calendar-alt"></i>
                        </span>
                    </div>
                    <asp:TextBox ID="txtFecha" CssClass="form-control" runat="server" data-inputmask-alias="datetime" data-inputmask-inputformat="dd/mm/yyyy" data-mask="datemask" im-insert="false"></asp:TextBox>
                </div>
                <!-- /.input group -->
            </div>
        </div>
        <div class="card-body row">
            <div class="form-group col-md-6 col-sm-6">
                <label for="ddlLugar">Lugar</label>
                <asp:DropDownList ID="ddlLugar" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Nombre"></asp:DropDownList>
            </div>
            <div class="form-group col-md-6 col-sm-6">
                <label for="ddlLugar">Ensayo</label>
                <asp:DropDownList ID="ddlEnsayo" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Nombre"></asp:DropDownList>
            </div>
        </div>
        <!-- /.card-body -->
        <div class="card-footer">
            <asp:Button ID="btnFiltrar" runat="server" class="btn btn-info" Text="Filtrar" OnClick="btnFiltrar_Click" />
            <%--<asp:Button ID="btnNuevo" runat="server" class="btn btn-success" Text="Nuevo" OnClick="btnNuevo_Click"  />--%>
        </div>

    </div>
    <div class="card">
        <div class="card-header">
            <h3 class="card-title">Asignación</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <asp:GridView ID="dtgPrincipal" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid"  DataKeyNames="ID" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnPageIndexChanging="dtgPrincipal_PageIndexChanging" OnSorting="dtgPrincipal_Sorting" OnRowCommand="dtgPrincipal_RowCommand" OnDataBound="dtgPrincipal_DataBound" OnRowCreated="dtgPrincipal_RowCreated">
                <Columns>
                    <%--<asp:BoundField HeaderText="#" DataField="Numero">
                        <ItemStyle Width="20px" />
                    </asp:BoundField>--%>
                    <%--<asp:ButtonField ButtonType="Button" HeaderText="Modificar" Text="modificar">
                        <ControlStyle CssClass="btn btn-primary" />
                    </asp:ButtonField>--%>
                    <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="Dias" HeaderText="Días" />
                    <asp:BoundField DataField="Lugar" HeaderText="Lugar" />
                    <asp:BoundField DataField ="Ensayo" HeaderText ="Ensayo" />
                    <asp:BoundField DataField="Actividad" HeaderText="Actividad" />
                    <asp:BoundField DataField="CantidadUsuarios" HeaderText="Cant. Usuarios" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnAsignacion" class="btn btn-success" runat="server" Text="Asignación" CommandName="Asignacion" CommandArgument='<%#Eval("Id") %>'></asp:Button>
                        </ItemTemplate>
                    </asp:TemplateField>                      
                </Columns>
                <PagerStyle CssClass="pagination pagination-sm float-right" />
            </asp:GridView>
        </div>
        <!-- /.card-body -->
        <!-- Modal Confimaciones Eliminar -->
        <div class="modal" id="DetalleASignacion" tabindex="-1" role="dialog" aria-labelledby="DetalleASignacionLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Asignación</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body"> 
                        <div class="form-group" hidden="hidden">
                            <asp:TextBox ID="txtProgActId" runat="server" class="form-control"></asp:TextBox>
                            <asp:TextBox ID="txtDias" runat="server" class="form-control"></asp:TextBox>
                            <asp:TextBox ID="txtIdTemporada" runat="server" class="form-control"></asp:TextBox>
                            <asp:TextBox ID="txtFechaAct" runat="server" class="form-control"></asp:TextBox>
                            <asp:TextBox ID="txtIdLugar" runat="server" class="form-control"></asp:TextBox>
                            <asp:TextBox ID="txtIdEnsayo" runat="server" class="form-control"></asp:TextBox>
                        </div>                                              
                        <div class="row">
                            <div class="form-group col-md-12 col-sm-12">
                                <label for="lstUsuario">Usuarios</label>
                                <asp:ListBox ID="lstUsuario" CssClass="form-control select2" DataValueField="Id" DataTextField="nombre_empleado" runat="server" SelectionMode="Multiple"></asp:ListBox>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnModalGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnModalGuardar_Click" />
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
