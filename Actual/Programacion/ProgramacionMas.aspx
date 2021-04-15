<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="ProgramacionMas.aspx.cs" Inherits="WEB.ProgramacionMas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
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
        <h1 class="m-0 text-dark">Programación Masiva</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="../Inicial/Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Programación Masiva</li>
        </ol>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- general form elements -->
    <div class="card card-default">
        <div class="card-header">
            <h3 class="card-title">Ingreso masiva de actividades</h3>
        </div>
        <!-- /.card-header -->
        <!-- form start -->
        <div class="card-body">
            <div class="row">

                <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlTemporada">Temporada</label>
                    <asp:DropDownList ID="ddlTemporada" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Nombre" AutoPostBack="True" OnSelectedIndexChanged="ddlTemporada_SelectedIndexChanged"></asp:DropDownList>

                </div>
                <div class="form-group col-md-6 col-sm-6">
                    <label for="lstLugar">Lugar</label>
                    <asp:DropDownList ID="ddlLugar" CssClass="form-control select2" DataValueField="Id" DataTextField="Nombre" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlLugar_SelectedIndexChanged" ></asp:DropDownList>
                </div>

            </div>
            <div class="row">
                <div class="form-group col-md-12 col-sm-12">
                    <label for="lstEnsayo">Ensayo</label>
                    <asp:ListBox ID="lstEnsayo" CssClass="form-control select2" DataValueField="Id" DataTextField="Codigo" runat="server" SelectionMode="Multiple" AutoPostBack="True" OnSelectedIndexChanged="lstEnsayo_SelectedIndexChanged"></asp:ListBox>
                </div>
            </div>

            <div class="row">

                <div class="form-group col-md-3 col-sm-3">
                    <label for="txtRangoFecha">Semana</label>

                    <div class="input-group">
                        <div class="input-group-text">
                            <asp:RadioButton ID="rbtSemana" runat="server" GroupName="1" AutoPostBack="true" OnCheckedChanged="rbtSemana_CheckedChanged"></asp:RadioButton>
                        </div>
                        <asp:TextBox ID="txtRangoFecha" runat="server" class="form-control" placeholder="Semana"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group col-md-3 col-sm-3">
                    <label for="lstDia">Días</label>
                    <asp:ListBox ID="lstDia" CssClass="form-control select2" DataValueField="Id" DataTextField="Dia" runat="server" SelectionMode="Multiple"></asp:ListBox>
                </div>

                <div class="form-group col-md-3 col-sm-3">
                    <label for="txtRangoFecha">DDS</label>

                    <div class="input-group" style="left: 0px; top: 0px">
                        <div class="input-group-text">
                            <asp:RadioButton ID="rbtFechaCosecha" runat="server" GroupName="1" AutoPostBack="true" OnCheckedChanged="rbtSemana_CheckedChanged"></asp:RadioButton>
                        </div>
                        <asp:TextBox ID="txtDiasCosecha" runat="server" class="form-control" placeholder="DDS" TextMode="Number" autocomplete="off"></asp:TextBox>
                    </div>
                </div>
                
                <div class="form-group col-md-3 col-sm-3">
                    <label for="ddlTratamiento">Tratamiento</label>
                    <asp:DropDownList ID="ddlTratamiento" runat="server" CssClass="form-control select2" DataValueField="Nombre" DataTextField="Nombre" Enabled="false"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-5 col-sm-5">
                    <label for="txtActividad">Actividad</label>
                    <asp:DropDownList ID="ddlActividad" runat="server" CssClass="form-control select2" DataValueField="Nombre" DataTextField="Nombre"></asp:DropDownList>
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
                <div class="form-group col-md-2 col-sm-2">
                    <label for="ddlDosis">Dosis</label>
                    <asp:TextBox ID="txtDosis" runat="server" class="form-control" placeholder="Dosis" TextMode="Number" autocomplete="off"></asp:TextBox>
                </div> 
                <div class="form-group col-md-2 col-sm-2">
                    <label for="ddlDosis">UM</label>
                    <asp:DropDownList ID="ddlUM" runat="server" CssClass="form-control select2" DataValueField="Id" DataTextField="Sigla"></asp:DropDownList>
                </div> 
                <div class="form-group col-md-2 col-sm-2">
                    <label for="ddlDosis">UM Longitud</label>
                    <asp:DropDownList ID="ddlUMValor" runat="server" CssClass="form-control select2" DataValueField="Id" DataTextField="Sigla"></asp:DropDownList>
                </div>
                
                <div class="form-group col-md-2 col-sm-2">
                    <label for="txtValorSuperficie">Valor Superficie</label>
                    <asp:TextBox ID="txtValorSuperficie" runat="server" class="form-control" placeholder="Valor Superficie" TextMode="Number" autocomplete="off"></asp:TextBox>
                </div> 
                <div class="form-group col-md-2 col-sm-2">
                    <label for="ddlSuperficie">Superficie Obj</label>
                    <asp:DropDownList ID="ddlSuperficieObj" runat="server" CssClass="form-control select2" DataValueField="Id" DataTextField="Sigla" AutoPostBack="true" OnSelectedIndexChanged="ddlSuperficieObj_SelectedIndexChanged"></asp:DropDownList>
                </div>
                
                <div class="form-group col-md-2 col-sm-2">
                    <label for="txtDosisTotal">Valor</label>
                    <asp:TextBox ID="txtDosisTotal" runat="server" class="form-control" placeholder="Valor" TextMode="Number" autocomplete="off"></asp:TextBox>
                </div> 
            </div>
            <div class="row">
                <div class="form-group col-md-12 col-sm-12">
                    <label for="txtObservaciones">Observaciones</label>
                    <asp:TextBox ID="txtObservaciones" runat="server" class="form-control" placeholder="Observaciones" autocomplete="off"></asp:TextBox>
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
            <asp:Button ID="btnAgregar" runat="server" class="btn btn-primary" Text="Previsualizar"  OnClick="btnAgregar_Click" />
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
    
    <div class="modal fade" id="modal-previsualizar" aria-hidden="true" style="display: none;">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Previsualización Programación</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>

                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12 col-sm-12">
                            <asp:GridView ID="dtgProgramacion" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" DataKeyNames="Id" >
                                <Columns>
                                    <asp:BoundField DataField="Temporada" HeaderText="Temporada" />
                                    <asp:BoundField DataField="Ensayo" HeaderText="Ensayo" />
                                    <asp:BoundField DataField="Lugar" HeaderText="Lugar" />
                                    <asp:BoundField DataField="Responsable" HeaderText="Responsable" />
                                    <asp:BoundField DataField="Actividad" HeaderText="Actividad" />
                                    <asp:BoundField DataField="FechaDesde" DataFormatString="{0:d}" HeaderText="Desde" />
                                    <asp:BoundField DataField="FechaHasta" DataFormatString="{0:d}" HeaderText="Hasta" />
                                    <asp:BoundField DataField="Dias" HeaderText="Días" />
                                    <asp:BoundField DataField="dds" HeaderText="Días Cosecha" />
                                    <asp:BoundField DataField="Prioridad" HeaderText="Prioridad" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                          <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                    <asp:Button ID="btnConfirmar" runat="server" CssClas="btn btn-primary" Text="Confirmar" OnClick="btnConfirmar_Click" />
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

</asp:Content>
