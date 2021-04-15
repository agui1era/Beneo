<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="Programacion.aspx.cs" Inherits="WEB.Programacion" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <%--<link rel="stylesheet" href="../AdminLte/plugins/select2/css/select2.min.css" />--%>

    <script type="text/javascript">
        var nowDate = new Date();
        var today = new Date(nowDate.getFullYear(), nowDate.getMonth(), nowDate.getDate(), 0, 0, 0, 0);
        $(function () {
            
            $('.select2').select2()

            $("#<%= dtgActividades.ClientID %>").DataTable({
                "responsive": true,
                "autoWidth": false
            });
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
            <li class="breadcrumb-item active">Programación</li>
        </ol>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="card card-default" data-select2-id="42">
        <div class="card-header">
            <h3 class="card-title">Actualización de Programación</h3>

            <div class="card-tools">
                <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
            </div>
        </div>
        <!-- /.card-header -->
        <!-- form start -->
        <div class="card-body">
            <div class="form-group" hidden="hidden">
                <label for="txtId">Id</label>
                <asp:TextBox ID="txtId" runat="server" class="form-control" placeholder="Id"></asp:TextBox>
            </div>
            <div class="row">

                <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlTemporada">Temporada</label>
                    <asp:DropDownList ID="ddlTemporada" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Nombre" AutoPostBack="True" OnSelectedIndexChanged="ddlTemporada_SelectedIndexChanged"></asp:DropDownList>

                </div>
                <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlLugar">Lugar</label>
                    <asp:DropDownList ID="ddlLugar" runat="server" CssClass="form-control select2" DataValueField="Id" DataTextField="Nombre" AutoPostBack="True" OnSelectedIndexChanged="ddlLugar_SelectedIndexChanged"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlEnsayo">Ensayo</label>
                    <asp:DropDownList ID="ddlEnsayo" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Codigo" AutoPostBack="True" OnSelectedIndexChanged="ddlEnsayo_SelectedIndexChanged" ViewStateMode="Enabled"></asp:DropDownList>
                </div>

                <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlResponsable">Responsable</label>
                    <asp:DropDownList ID="ddlResponsable" runat="server" CssClass="form-control select2" DataValueField="Id" DataTextField="nombre_empleado"></asp:DropDownList>
                </div>

            </div>

        </div>
        <!-- /.card-body -->
        <div class="card-footer">

            <asp:Button ID="btnGuardar" runat="server" class="btn btn-primary" Text="Guardar" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnEliminar" runat="server" class="btn btn-danger" Text="Eliminar" OnClick="btnEliminar_Click" />
            <asp:Button ID="btnNuevo" runat="server" class="btn btn-info" Text="Nuevo" OnClick="btnNuevo_Click" />
        </div>

    </div>

    <div class="card card-default" id="cardActividades" runat="server">
        <div class="card-header">
            <h3 class="card-title">Ingreso de Actividades</h3>
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
                        <div class="col-md-12 col-sm-12">
                            <asp:GridView ID="dtgActividades" runat="server" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" AutoGenerateColumns="False" DataKeyNames="Id" OnPageIndexChanging="dtgActividades_PageIndexChanging" OnRowCommand="dtgActividades_RowCommand" OnDataBound="dtgActividades_DataBound" OnRowCreated="dtgActividades_RowCreated">
                                <Columns>
                                    <asp:BoundField DataField="Actividad" HeaderText="Actividad" />
                                    <asp:BoundField DataField="FechaDesde" DataFormatString="{0:d}" HeaderText="Desde" />
                                    <asp:BoundField DataField="FechaHasta" DataFormatString="{0:d}" HeaderText="Hasta" />
                                    <asp:BoundField DataField="Dias" HeaderText="Días" />
                                    <asp:BoundField DataField="Prioridad" HeaderText="Prioridad" />
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:Button ID="btnModificar" class="btn btn-success" runat="server" Text="Modificar" CommandName="Modificar" CommandArgument='<%#Eval("Id") %>'></asp:Button>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <!-- /.card-body -->
        <div class="card-footer">
            <asp:Button ID="btnAgregarAct" runat="server" class="btn btn-primary" Text="Agregar Actividad" OnClick="btnAgregarAct_Click" />            
       </div>

    </div>

    
</asp:Content>
