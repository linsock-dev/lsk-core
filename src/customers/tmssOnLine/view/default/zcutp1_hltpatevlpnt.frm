<?php
  require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');
  require_once('library/plugins/phptools/tcpdf/6.7.4/include/tcpdf_filters.php');
  $pdf = new TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);

  $lv_bustxt = trim((string)($vew_sec->bustxt??($vew_sec->buscod??'')));
  if($lv_bustxt===''){
    $lv_bustxt = 'TEMASIS';
  }

  $pdf->SetCreator('TEMASIS');
  $pdf->SetAuthor($lv_bustxt);
  $pdf->SetTitle('Ficha de evolucion '.$vew_data->evlcod);
  $pdf->setPrintHeader(false);
  $pdf->setPrintFooter(false);
  $pdf->SetMargins(0, 0, 0);
  $pdf->SetAutoPageBreak(false, 0);
  $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

  $lv_txt = function($lp_value){
    if($lp_value===null){
      return '';
    }
    if($lp_value instanceof DateTimeInterface){
      return $lp_value->format('d/m/Y');
    }
    $lv_value = (string)$lp_value;
    if(function_exists('mb_check_encoding') && !mb_check_encoding($lv_value, 'UTF-8')){
      $lv_converted = @iconv('Windows-1252', 'UTF-8//IGNORE', $lv_value);
      if($lv_converted!==false){
        $lv_value = $lv_converted;
      }
    }
    return $lv_value;
  };

  $lv_date = function($lp_value) use ($lv_txt){
    if($lp_value instanceof DateTimeInterface){
      return $lp_value->format('d/m/Y');
    }
    $lv_value = trim($lv_txt($lp_value));
    if($lv_value===''){
      return '';
    }
    try{
      return (new DateTime($lv_value))->format('d/m/Y');
    }catch(Exception $lo_exception){
      return $lv_value;
    }
  };

  $lv_isyes = function($lp_value) use ($lv_txt){
    return in_array(strtoupper(trim($lv_txt($lp_value))), array('1', 'ON', 'SI', 'SÍ', 'YES', 'TRUE', 'X'), true);
  };

  $lv_box = function($lp_pdf, $lp_x, $lp_y, $lp_w, $lp_h, $lp_fill, $lp_stroke, $lp_linewidth=0.25){
    $lp_pdf->SetLineWidth($lp_linewidth);
    $lp_pdf->SetDrawColor($lp_stroke[0], $lp_stroke[1], $lp_stroke[2]);
    $lp_pdf->SetFillColor($lp_fill[0], $lp_fill[1], $lp_fill[2]);
    $lp_pdf->RoundedRect($lp_x, $lp_y, $lp_w, $lp_h, 2.2, '1111', 'DF');
  };

  $lv_field = function($lp_pdf, $lp_label, $lp_value, $lp_x, $lp_y, $lp_w, $lp_emphasis=false) use ($lv_txt){
    $lp_pdf->SetTextColor(104, 119, 139);
    $lp_pdf->SetFont('helvetica', 'B', 5.5);
    $lp_pdf->SetXY($lp_x, $lp_y);
    $lp_pdf->Cell($lp_w, 2.8, strtoupper($lv_txt($lp_label)), 0, 0, 'L', false, '', 1);

    $lp_pdf->SetTextColor(34, 48, 68);
    $lp_pdf->SetFont('helvetica', $lp_emphasis?'B':'', $lp_emphasis?8.6:7.4);
    $lp_pdf->SetXY($lp_x, $lp_y + 3.4);
    $lp_pdf->Cell($lp_w, 3.8, $lv_txt($lp_value)===''?'-':$lv_txt($lp_value), 0, 0, 'L', false, '', 1);
  };

  $lv_fitrect = function($lp_srcw, $lp_srch, $lp_x, $lp_y, $lp_maxw, $lp_maxh){
    if($lp_srcw<=0 || $lp_srch<=0){
      return array($lp_x, $lp_y, $lp_maxw, $lp_maxh);
    }
    $lv_scale = min($lp_maxw/$lp_srcw, $lp_maxh/$lp_srch);
    $lv_w = $lp_srcw*$lv_scale;
    $lv_h = $lp_srch*$lv_scale;
    return array($lp_x+(($lp_maxw-$lv_w)/2), $lp_y+(($lp_maxh-$lv_h)/2), $lv_w, $lv_h);
  };

  // TCPDF no aplica la orientacion EXIF de los JPG. Se lee directamente el
  // tag 0x0112 para respetar la posicion en la que fue tomada la fotografia.
  $lv_jpegorientation = function($lp_path){
    $lv_data = @file_get_contents($lp_path, false, null, 0, 262144);
    if($lv_data===false || strlen($lv_data)<12 || substr($lv_data, 0, 2)!=="\xFF\xD8"){
      return 1;
    }

    $lv_read16 = function($lp_data, $lp_offset, $lp_little){
      if($lp_offset<0 || ($lp_offset+2)>strlen($lp_data)){
        return 0;
      }
      $lv_value = unpack($lp_little?'v':'n', substr($lp_data, $lp_offset, 2));
      return (int)($lv_value[1]??0);
    };
    $lv_read32 = function($lp_data, $lp_offset, $lp_little){
      if($lp_offset<0 || ($lp_offset+4)>strlen($lp_data)){
        return 0;
      }
      $lv_value = unpack($lp_little?'V':'N', substr($lp_data, $lp_offset, 4));
      return (int)($lv_value[1]??0);
    };

    $lv_pos = 2;
    $lv_length = strlen($lv_data);
    while(($lv_pos+4)<$lv_length){
      if(ord($lv_data[$lv_pos])!==0xFF){
        $lv_pos++;
        continue;
      }
      while($lv_pos<$lv_length && ord($lv_data[$lv_pos])===0xFF){
        $lv_pos++;
      }
      if($lv_pos>=$lv_length){
        break;
      }
      $lv_marker = ord($lv_data[$lv_pos]);
      $lv_pos++;
      if($lv_marker===0xD8 || ($lv_marker>=0xD0 && $lv_marker<=0xD9)){
        continue;
      }
      $lv_segmentlength = $lv_read16($lv_data, $lv_pos, false);
      if($lv_segmentlength<2 || ($lv_pos+$lv_segmentlength)>$lv_length){
        break;
      }
      $lv_segmentstart = $lv_pos+2;
      if($lv_marker===0xE1 && substr($lv_data, $lv_segmentstart, 6)==="Exif\x00\x00"){
        $lv_tiffstart = $lv_segmentstart+6;
        $lv_byteorder = substr($lv_data, $lv_tiffstart, 2);
        if($lv_byteorder==='II' || $lv_byteorder==='MM'){
          $lv_little = ($lv_byteorder==='II');
          $lv_ifdoffset = $lv_read32($lv_data, $lv_tiffstart+4, $lv_little);
          $lv_ifdstart = $lv_tiffstart+$lv_ifdoffset;
          $lv_entrycount = $lv_read16($lv_data, $lv_ifdstart, $lv_little);
          for($lv_entry=0; $lv_entry<$lv_entrycount; $lv_entry++){
            $lv_entrystart = $lv_ifdstart+2+($lv_entry*12);
            if(($lv_entrystart+12)>$lv_length){
              break;
            }
            if($lv_read16($lv_data, $lv_entrystart, $lv_little)===0x0112){
              $lv_orientation = $lv_read16($lv_data, $lv_entrystart+8, $lv_little);
              return ($lv_orientation>=1 && $lv_orientation<=8)?$lv_orientation:1;
            }
          }
        }
      }
      $lv_pos += $lv_segmentlength;
    }
    return 1;
  };

  // Los adjuntos PDF de enfermeria son escaneos. Se recuperan sus imagenes
  // JPEG embebidas usando solamente PHP y las utilidades incluidas en TCPDF.
  $lv_extractpdfimages = function($lp_path){
    $lv_images = array();
    $lv_hashes = array();
    $lv_pdfdata = @file_get_contents($lp_path);
    if($lv_pdfdata===false || strpos($lv_pdfdata, '%PDF-')===false){
      return $lv_images;
    }

    $lv_offset = 0;
    $lv_pdfstrlen = strlen($lv_pdfdata);
    while($lv_offset<$lv_pdfstrlen && preg_match('/\/Subtype\s*\/Image\b/is', $lv_pdfdata, $lv_match, PREG_OFFSET_CAPTURE, $lv_offset)){
      $lv_imagepos = $lv_match[0][1];
      $lv_streampos = strpos($lv_pdfdata, 'stream', $lv_imagepos);
      $lv_endobjpos = strpos($lv_pdfdata, 'endobj', $lv_imagepos);
      if($lv_streampos===false || ($lv_endobjpos!==false && $lv_streampos>$lv_endobjpos)){
        $lv_offset = $lv_imagepos+strlen($lv_match[0][0]);
        continue;
      }

      $lv_objsearchstart = max(0, $lv_imagepos-8192);
      $lv_objprefix = substr($lv_pdfdata, $lv_objsearchstart, $lv_imagepos-$lv_objsearchstart);
      $lv_objrelative = strrpos($lv_objprefix, 'obj');
      $lv_objstart = ($lv_objrelative===false?$lv_objsearchstart:$lv_objsearchstart+$lv_objrelative+3);
      $lv_dictstart = strpos($lv_pdfdata, '<<', $lv_objstart);
      if($lv_dictstart===false || $lv_dictstart>$lv_imagepos){
        $lv_dictstart = $lv_imagepos;
      }
      $lv_dictionary = substr($lv_pdfdata, $lv_dictstart, $lv_streampos-$lv_dictstart);

      $lv_streamstart = $lv_streampos+6;
      if(substr($lv_pdfdata, $lv_streamstart, 2)==="\r\n"){
        $lv_streamstart += 2;
      }elseif(substr($lv_pdfdata, $lv_streamstart, 1)==="\n" || substr($lv_pdfdata, $lv_streamstart, 1)==="\r"){
        $lv_streamstart++;
      }
      $lv_streamend = strpos($lv_pdfdata, 'endstream', $lv_streamstart);
      if($lv_streamend===false){
        break;
      }

      $lv_stream = substr($lv_pdfdata, $lv_streamstart, $lv_streamend-$lv_streamstart);
      preg_match_all('/\/(ASCII85Decode|ASCIIHexDecode|FlateDecode|LZWDecode|RunLengthDecode|DCTDecode)\b/i', $lv_dictionary, $lv_filters);
      $lv_hasdct = false;
      if(isset($lv_filters[1])){
        foreach($lv_filters[1] as $lv_filter){
          $lv_filternme = strtolower($lv_filter);
          $lv_filtermap = array(
            'ascii85decode'=>'ASCII85Decode',
            'asciihexdecode'=>'ASCIIHexDecode',
            'flatedecode'=>'FlateDecode',
            'lzwdecode'=>'LZWDecode',
            'runlengthdecode'=>'RunLengthDecode',
            'dctdecode'=>'DCTDecode'
          );
          $lv_filter = $lv_filtermap[$lv_filternme]??$lv_filter;
          if($lv_filter==='DCTDecode'){
            $lv_hasdct = true;
            break;
          }
          if(class_exists('TCPDF_FILTERS')){
            try{
              $lv_stream = TCPDF_FILTERS::decodeFilter($lv_filter, $lv_stream);
            }catch(Exception $lo_exception){
              $lv_stream = '';
              break;
            }
          }
        }
      }

      if($lv_hasdct && $lv_stream!=''){
        $lv_jpgstart = strpos($lv_stream, "\xFF\xD8");
        $lv_jpgend = strrpos($lv_stream, "\xFF\xD9");
        if($lv_jpgstart!==false && $lv_jpgend!==false && $lv_jpgend>$lv_jpgstart){
          $lv_jpeg = substr($lv_stream, $lv_jpgstart, ($lv_jpgend-$lv_jpgstart)+2);
          $lv_info = function_exists('getimagesizefromstring')?@getimagesizefromstring($lv_jpeg):false;
          if($lv_info!==false && $lv_info[0]>=300 && $lv_info[1]>=300){
            $lv_hash = md5($lv_jpeg);
            if(!isset($lv_hashes[$lv_hash])){
              $lv_images[] = array('data'=>$lv_jpeg, 'width'=>$lv_info[0], 'height'=>$lv_info[1]);
              $lv_hashes[$lv_hash] = true;
            }
          }
        }
      }
      $lv_offset = $lv_streamend+9;
    }

    unset($lv_pdfdata);
    return $lv_images;
  };

  // DOCX es un contenedor ZIP/OOXML. Se recuperan texto e imagenes sin
  // extraer archivos al disco y sin ejecutar macros u objetos embebidos.
  $lv_extractdocxcontent = function($lp_path){
    $lv_result = array('blocks'=>array(), 'errors'=>array());
    if(!class_exists('ZipArchive') || !class_exists('DOMDocument')){
      $lv_result['errors'][] = 'El servidor no dispone de ZipArchive o DOMDocument';
      return $lv_result;
    }

    $lv_filesize = @filesize($lp_path);
    if($lv_filesize===false || $lv_filesize<=0 || $lv_filesize>(25*1024*1024)){
      $lv_result['errors'][] = 'El DOCX supera el límite permitido de 25 MB o está vacío';
      return $lv_result;
    }

    $lv_zip = new ZipArchive();
    if($lv_zip->open($lp_path)!==true){
      $lv_result['errors'][] = 'No se pudo abrir el contenedor DOCX';
      return $lv_result;
    }

    if($lv_zip->numFiles>500){
      $lv_result['errors'][] = 'El DOCX contiene demasiados archivos internos';
      $lv_zip->close();
      return $lv_result;
    }

    $lv_uncompressedsize = 0;
    for($lv_zipidx=0; $lv_zipidx<$lv_zip->numFiles; $lv_zipidx++){
      $lv_zipstat = $lv_zip->statIndex($lv_zipidx);
      $lv_entrysize = (int)($lv_zipstat['size']??0);
      if($lv_entrysize>(25*1024*1024)){
        $lv_result['errors'][] = 'El DOCX contiene un elemento interno demasiado grande';
        $lv_zip->close();
        return $lv_result;
      }
      $lv_uncompressedsize += $lv_entrysize;
      if($lv_uncompressedsize>(80*1024*1024)){
        $lv_result['errors'][] = 'El contenido descomprimido del DOCX supera el límite permitido';
        $lv_zip->close();
        return $lv_result;
      }
    }

    $lv_documentxml = $lv_zip->getFromName('word/document.xml');
    if($lv_documentxml===false || strlen($lv_documentxml)>(8*1024*1024)){
      $lv_result['errors'][] = 'El DOCX no contiene un documento principal compatible';
      $lv_zip->close();
      return $lv_result;
    }

    $lv_normalizepath = function($lp_base, $lp_target){
      $lv_target = str_replace('\\', '/', trim((string)$lp_target));
      if($lv_target==='' || substr($lv_target, 0, 1)==='/' || preg_match('/^[a-z][a-z0-9+.-]*:/i', $lv_target)){
        return '';
      }
      $lv_parts = explode('/', dirname($lp_base).'/'.$lv_target);
      $lv_cleanparts = array();
      foreach($lv_parts as $lv_part){
        if($lv_part==='' || $lv_part==='.'){
          continue;
        }
        if($lv_part==='..'){
          if(count($lv_cleanparts)===0){
            return '';
          }
          array_pop($lv_cleanparts);
          continue;
        }
        $lv_cleanparts[] = $lv_part;
      }
      $lv_cleanpath = implode('/', $lv_cleanparts);
      return strpos($lv_cleanpath, 'word/')===0?$lv_cleanpath:'';
    };

    $lv_relationships = array();
    $lv_relsxml = $lv_zip->getFromName('word/_rels/document.xml.rels');
    if($lv_relsxml!==false && strlen($lv_relsxml)<=(2*1024*1024)){
      $lv_relsdom = new DOMDocument();
      if(@$lv_relsdom->loadXML($lv_relsxml, LIBXML_NONET|LIBXML_NOERROR|LIBXML_NOWARNING)){
        foreach($lv_relsdom->getElementsByTagName('Relationship') as $lv_relnode){
          if(strtolower($lv_relnode->getAttribute('TargetMode'))==='external'){
            continue;
          }
          $lv_relid = $lv_relnode->getAttribute('Id');
          $lv_relpath = $lv_normalizepath('word/document.xml', $lv_relnode->getAttribute('Target'));
          if($lv_relid!=='' && strpos($lv_relpath, 'word/media/')===0){
            $lv_relationships[$lv_relid] = $lv_relpath;
          }
        }
      }
      unset($lv_relsdom);
    }

    $lv_documentdom = new DOMDocument();
    if(!@$lv_documentdom->loadXML($lv_documentxml, LIBXML_NONET|LIBXML_NOERROR|LIBXML_NOWARNING)){
      $lv_result['errors'][] = 'El XML principal del DOCX no es válido';
      $lv_zip->close();
      return $lv_result;
    }

    $lv_xpath = new DOMXPath($lv_documentdom);
    $lv_xpath->registerNamespace('w', 'http://schemas.openxmlformats.org/wordprocessingml/2006/main');
    $lv_xpath->registerNamespace('a', 'http://schemas.openxmlformats.org/drawingml/2006/main');
    $lv_xpath->registerNamespace('v', 'urn:schemas-microsoft-com:vml');
    $lv_relationshipns = 'http://schemas.openxmlformats.org/officeDocument/2006/relationships';
    $lv_imagecount = 0;
    $lv_textlength = 0;
    $lv_paragraphs = $lv_xpath->query('//w:body//w:p');

    foreach($lv_paragraphs as $lv_paragraph){
      $lv_textbuffer = '';
      $lv_tokens = $lv_xpath->query('.//*[self::w:t or self::w:tab or self::w:br or self::w:cr or self::a:blip or self::v:imagedata]', $lv_paragraph);
      foreach($lv_tokens as $lv_token){
        $lv_localname = $lv_token->localName;
        if($lv_localname==='t'){
          $lv_textbuffer .= $lv_token->nodeValue;
          continue;
        }
        if($lv_localname==='tab'){
          $lv_textbuffer .= '    ';
          continue;
        }
        if($lv_localname==='br' || $lv_localname==='cr'){
          $lv_textbuffer .= "\n";
          continue;
        }

        $lv_cleantext = trim($lv_textbuffer);
        if($lv_cleantext!==''){
          $lv_textlength += strlen($lv_cleantext);
          if($lv_textlength<=250000){
            $lv_result['blocks'][] = array('type'=>'text', 'text'=>$lv_cleantext);
          }
        }
        $lv_textbuffer = '';

        $lv_relid = ($lv_localname==='blip')
          ? $lv_token->getAttributeNS($lv_relationshipns, 'embed')
          : $lv_token->getAttributeNS($lv_relationshipns, 'id');
        $lv_mediapath = $lv_relationships[$lv_relid]??'';
        if($lv_mediapath==='' || $lv_imagecount>=40){
          continue;
        }
        $lv_imagedata = $lv_zip->getFromName($lv_mediapath);
        if($lv_imagedata===false || strlen($lv_imagedata)>(20*1024*1024)){
          continue;
        }
        $lv_imageinfo = function_exists('getimagesizefromstring')?@getimagesizefromstring($lv_imagedata):false;
        $lv_imagetype = '';
        if($lv_imageinfo!==false){
          if(($lv_imageinfo[2]??0)===IMAGETYPE_JPEG){
            $lv_imagetype = 'JPG';
          }elseif(($lv_imageinfo[2]??0)===IMAGETYPE_PNG){
            $lv_imagetype = 'PNG';
          }
        }
        if($lv_imagetype!==''){
          $lv_result['blocks'][] = array(
            'type'=>'image',
            'data'=>$lv_imagedata,
            'width'=>$lv_imageinfo[0],
            'height'=>$lv_imageinfo[1],
            'imagetype'=>$lv_imagetype
          );
          $lv_imagecount++;
        }
      }

      $lv_cleantext = trim($lv_textbuffer);
      if($lv_cleantext!==''){
        $lv_textlength += strlen($lv_cleantext);
        if($lv_textlength<=250000){
          $lv_result['blocks'][] = array('type'=>'text', 'text'=>$lv_cleantext);
        }
      }
    }

    if($lv_textlength>250000){
      $lv_result['errors'][] = 'El texto del DOCX fue limitado a 250.000 caracteres';
    }
    if($lv_imagecount>=40){
      $lv_result['errors'][] = 'Las imágenes del DOCX fueron limitadas a 40';
    }
    if(count($lv_result['blocks'])===0){
      $lv_result['errors'][] = 'El DOCX no contiene texto ni imágenes JPG/PNG compatibles';
    }

    $lv_zip->close();
    unset($lv_documentdom, $lv_documentxml);
    return $lv_result;
  };

  $lv_evlatr = strtoupper($vew_data->evlatr001??'');
  $lv_evlatrrow = $vew_doc->getTagValue($lv_evlatr, 'row');
  $lv_realizadoval = $vew_doc->getTagValue($lv_evlatrrow, 'evlinfprc');
  $lv_realizada = ($lv_realizadoval==='') ? (($vew_data->docsts??'')==='A') : $lv_isyes($lv_realizadoval);
  $lv_fvrpt = $lv_isyes($vew_doc->getTagValue($lv_evlatrrow, 'fvrpt'));
  $lv_motivocod = trim($lv_txt($vew_doc->getTagValue($lv_evlatrrow, 'evlcncmtv')));
  $lv_motivokey = strtoupper($lv_motivocod);
  $lv_motivotxt = $lv_motivocod;
  foreach($vew_evlcncmtvlst as $lv_motivolstcod=>$lv_motivolsttxt){
    if(strtoupper(trim($lv_txt($lv_motivolstcod)))===$lv_motivokey){
      $lv_motivotxt = trim($lv_txt($lv_motivolsttxt));
      break;
    }
  }
  $lv_motivocmt = trim($lv_txt($vew_doc->getTagValue($lv_evlatrrow, 'evlcnccmt')));
  $lv_dosis = trim($lv_txt($vew_doc->getTagValue($lv_evlatrrow, 'matdos')));
  $lv_dosisunt = trim($lv_txt($vew_doc->getTagValue($lv_evlatrrow, 'matuntcod')));
  if($lv_dosisunt!=''){
    $lv_dosis .= ($lv_dosis!=''?' ':'').$lv_dosisunt;
  }

  $lv_ooss = trim($lv_txt($vew_pat->per->hhrmedcovtxt??''));
  $lv_oossplan = trim($lv_txt($vew_pat->per->hhrmedcovaflpln??''));
  if($lv_oossplan!=''){
    $lv_ooss .= ($lv_ooss!=''?' - ':'').$lv_oossplan;
  }
  $lv_afiliado = trim($lv_txt($vew_pat->per->hhrmedcovaflnum??''));
  $lv_prstxt = trim($lv_txt($vew_prs->prstxt??($vew_data->prstxt??'')));

  $pdf->AddPage('P', 'A4');

  // Cabecera principal.
  $pdf->SetFillColor(23, 56, 95);
  $pdf->Rect(0, 0, 210, 15, 'F');
  $pdf->SetTextColor(255, 255, 255);
  $pdf->SetFont('helvetica', 'B', 14);
  $pdf->Text(12, 4.6, 'FICHA DE EVOLUCIÓN');
  $pdf->SetFont('helvetica', 'B', 5.5);
  $pdf->Text(132, 2.7, 'NRO. DE EVOLUCIÓN');
  $pdf->SetFont('helvetica', 'B', 11.5);
  $pdf->Text(132, 7, $lv_txt($vew_data->evlcod));
  $pdf->SetFont('helvetica', 'B', 10.5);
  $pdf->SetXY(160, 5.1);
  $pdf->Cell(38, 5, $lv_txt($lv_bustxt), 0, 0, 'R', false, '', 1);

  // Datos del paciente y cobertura.
  $lv_box($pdf, 12, 18, 186, 20, array(255, 255, 255), array(205, 215, 226));
  $pdf->SetDrawColor(205, 215, 226);
  $pdf->SetLineWidth(0.18);
  $pdf->Line(16, 28, 194, 28);
  $lv_field($pdf, 'Paciente', ($vew_data->pattxt??'').' ('.($vew_data->patcod??'').')', 16, 20, 72, true);
  $lv_field($pdf, 'Fecha', $lv_date($vew_data->evldte??''), 94, 20, 27, true);
  $lv_field($pdf, 'Financiador', $vew_financiadortxt, 130, 20, 64, false);
  $lv_field($pdf, 'Prestador', $lv_prstxt, 16, 29.4, 61, false);
  $lv_field($pdf, 'Especialidad', $vew_data->spctxt??'', 86, 29.4, 29, false);
  $lv_field($pdf, 'Obra social / OOSS', $lv_ooss, 124, 29.4, 36, false);
  $lv_field($pdf, 'Nro. afiliado', $lv_afiliado, 167, 29.4, 27, false);

  // Estado de la prestacion. Farmacovigilancia conserva siempre la misma posicion.
  if($lv_realizada){
    $lv_box($pdf, 12, 41, 99, 11.5, array(234, 247, 241), array(139, 205, 180));
    $pdf->SetTextColor(22, 122, 85);
    $pdf->SetFont('helvetica', 'B', 5.5);
    $pdf->Text(17, 43.7, 'PRESTACIÓN');
    $pdf->SetFont('helvetica', 'B', 8.1);
    $pdf->Text(17, 47.2, 'REALIZADA: SÍ');
  }else{
    $lv_box($pdf, 12, 41, 32, 11.5, array(252, 238, 238), array(217, 155, 155));
    $pdf->SetTextColor(166, 59, 59);
    $pdf->SetFont('helvetica', 'B', 5.3);
    $pdf->Text(16, 43.7, 'PRESTACIÓN');
    $pdf->SetFont('helvetica', 'B', 7.2);
    $pdf->SetXY(16, 47.1);
    $pdf->Cell(24, 3.2, 'NO REALIZADA', 0, 0, 'L', false, '', 1);

    $lv_box($pdf, 47, 41, 64, 11.5, array(255, 255, 255), array(217, 155, 155));
    $pdf->SetTextColor(166, 59, 59);
    $pdf->SetFont('helvetica', 'B', 5.3);
    $pdf->Text(51, 43.7, 'MOTIVO');
    $pdf->SetTextColor(34, 48, 68);
    $pdf->SetFont('helvetica', 'B', 5.5);
    $pdf->SetXY(51, 47.1);
    $pdf->Cell(56, 3.2, $lv_motivotxt===''?'-':$lv_motivotxt, 0, 0, 'L', false, '', 1);
  }

  if($lv_fvrpt){
    $lv_box($pdf, 114, 41, 84, 11.5, array(255, 244, 215), array(230, 182, 93), 0.35);
    $pdf->SetDrawColor(154, 90, 0);
    $pdf->SetLineWidth(0.35);
    $pdf->Line(119, 50.1, 121.8, 43.6);
    $pdf->Line(121.8, 43.6, 124.6, 50.1);
    $pdf->Line(124.6, 50.1, 119, 50.1);
    $pdf->SetTextColor(154, 90, 0);
    $pdf->SetFont('helvetica', 'B', 5.5);
    $pdf->Text(128, 43.7, 'FARMACOVIGILANCIA');
    $pdf->SetFont('helvetica', 'B', 7.7);
    $pdf->Text(128, 47.2, 'SÍ - REQUIERE INFORME');
  }else{
    $lv_box($pdf, 114, 41, 84, 11.5, array(245, 247, 250), array(205, 215, 226));
    $pdf->SetTextColor(104, 119, 139);
    $pdf->SetFont('helvetica', 'B', 5.5);
    $pdf->Text(119, 43.7, 'FARMACOVIGILANCIA');
    $pdf->SetFont('helvetica', 'B', 7.7);
    $pdf->Text(119, 47.2, 'NO - SIN REPORTE');
  }

  // Medicamentos. Solo corresponden cuando la prestacion fue realizada.
  $lv_medrows = is_array($vew_data->evlmat??null)?$vew_data->evlmat:array();
  $lv_medrowcnt = max(1, count($lv_medrows));
  $lv_medy = 55.5;
  $lv_medh = 0;
  if($lv_realizada){
    $lv_medh = 10 + ($lv_medrowcnt*4);
    $lv_box($pdf, 12, $lv_medy, 186, $lv_medh, array(238, 245, 251), array(171, 199, 223));
    $pdf->SetTextColor(47, 110, 165);
    $pdf->SetFont('helvetica', 'B', 5.7);
    $pdf->Text(16, $lv_medy+2.5, 'MEDICAMENTO/S');

    $lv_medcols = array(
      array('MEDICAMENTO', 16, 62),
      array('DOSIS', 82, 27),
      array('CANTIDAD', 112, 26),
      array('LOTE', 141, 26),
      array('VENCIMIENTO', 170, 24)
    );
    $pdf->SetTextColor(104, 119, 139);
    $pdf->SetFont('helvetica', 'B', 5.1);
    foreach($lv_medcols as $lv_medcol){
      $pdf->SetXY($lv_medcol[1], $lv_medy+5.6);
      $pdf->Cell($lv_medcol[2], 2.8, $lv_medcol[0], 0, 0, 'L', false, '', 1);
    }

    $pdf->SetTextColor(34, 48, 68);
    $pdf->SetFont('helvetica', '', 7.2);
    if(count($lv_medrows)>0){
      $lv_medi = 0;
      foreach($lv_medrows as $lv_medrow){
        $lv_medyrow = $lv_medy+9.1+($lv_medi*4);
        $lv_medvals = array(
          array($lv_txt($lv_medrow['mattxt']??''), 16, 62),
          array($lv_dosis, 82, 27),
          array(trim($lv_txt($lv_medrow['matqty']??'').' '.$lv_txt($lv_medrow['matuntcod']??'')), 112, 26),
          array($lv_txt($lv_medrow['matbchcodext']??''), 141, 26),
          array($lv_date($lv_medrow['matbchduedte']??''), 170, 24)
        );
        foreach($lv_medvals as $lv_medval){
          $pdf->SetXY($lv_medval[1], $lv_medyrow);
          $pdf->Cell($lv_medval[2], 3.1, $lv_medval[0]===''?'-':$lv_medval[0], 0, 0, 'L', false, '', 1);
        }
        $lv_medi++;
      }
    }else{
      $pdf->SetXY(16, $lv_medy+9.1);
      $pdf->Cell(178, 3.1, 'Sin medicación registrada', 0, 0, 'L', false, '', 1);
    }
  }

  // En una prestacion no realizada, el formulario registra la observacion en evlcnccmt.
  $lv_evltitle = $lv_realizada?'EVOLUCIÓN CLÍNICA':'OBSERVACIONES';
  $lv_evltxt = $lv_realizada
    ? trim($lv_txt($vew_data->evlevl??''))
    : $lv_motivocmt;
  $lv_evly = $lv_realizada?($lv_medy+$lv_medh+3):$lv_medy;
  $lv_evlh = 23.5;
  $lv_box($pdf, 12, $lv_evly, 186, $lv_evlh, array(255, 255, 255), array(205, 215, 226));
  $pdf->SetTextColor(23, 56, 95);
  $pdf->SetFont('helvetica', 'B', 5.8);
  $pdf->Text(16, $lv_evly+2.8, $lv_evltitle);
  $pdf->SetTextColor(34, 48, 68);
  $pdf->SetFont('helvetica', '', 6.9);
  $pdf->MultiCell(178, $lv_evlh-8, $lv_evltxt===''?'-':$lv_evltxt, 0, 'L', false, 1, 16, $lv_evly+6.1, true, 0, false, true, $lv_evlh-8, 'T', true);

  // Area disponible para la primera pagina del adjunto.
  $lv_atttitley = $lv_evly+$lv_evlh+3;
  $lv_firstattachment = reset($vew_fleslt);
  $lv_firstfilename = $lv_firstattachment['fledata']['flenme']??'';
  $pdf->SetTextColor(23, 56, 95);
  $pdf->SetFont('helvetica', 'B', 6.4);
  $pdf->Text(12, $lv_atttitley, 'DOCUMENTACIÓN ADJUNTA');
  $pdf->SetTextColor(104, 119, 139);
  $pdf->SetFont('helvetica', '', 6.2);
  $pdf->SetXY(120, $lv_atttitley-0.5);
  $pdf->Cell(78, 3.5, $lv_txt($lv_firstfilename), 0, 0, 'R', false, '', 1);

  $lv_firstarea = array(12, $lv_atttitley+4, 186, 288-($lv_atttitley+4));
  $lv_fullarea = array(8, 8, 194, 281);
  $lv_attachmentplaced = false;
  $lv_attachmenterrors = array();

  $lv_addattachmentpage = function($lp_filename) use ($pdf, $lv_txt){
    $pdf->AddPage('P', 'A4');
    $pdf->SetTextColor(104, 119, 139);
    $pdf->SetFont('helvetica', '', 5.8);
    $pdf->SetXY(8, 3);
    $pdf->Cell(194, 3, $lv_txt($lp_filename), 0, 0, 'R', false, '', 1);
  };

  $lv_renderimage = function($lp_source, $lp_srcw, $lp_srch, $lp_area, $lp_type, $lp_rotation=0) use ($pdf, $lv_fitrect){
    $lv_rotation = ((int)$lp_rotation%360+360)%360;
    $lv_swapdimensions = ($lv_rotation===90 || $lv_rotation===270);
    $lv_fitw = $lv_swapdimensions?$lp_srch:$lp_srcw;
    $lv_fith = $lv_swapdimensions?$lp_srcw:$lp_srch;
    $lv_rect = $lv_fitrect($lv_fitw, $lv_fith, $lp_area[0], $lp_area[1], $lp_area[2], $lp_area[3]);

    if($lv_rotation!==0){
      $lv_centerx = $lv_rect[0]+($lv_rect[2]/2);
      $lv_centery = $lv_rect[1]+($lv_rect[3]/2);
      $pdf->StartTransform();
      $pdf->Rotate($lv_rotation, $lv_centerx, $lv_centery);
      if($lv_swapdimensions){
        $pdf->Image($lp_source, $lv_centerx-($lv_rect[3]/2), $lv_centery-($lv_rect[2]/2), $lv_rect[3], $lv_rect[2], $lp_type, '', 'T', true, 150, '', false, false, 0, false, false, false);
      }else{
        $pdf->Image($lp_source, $lv_rect[0], $lv_rect[1], $lv_rect[2], $lv_rect[3], $lp_type, '', 'T', true, 150, '', false, false, 0, false, false, false);
      }
      $pdf->StopTransform();
    }else{
      $pdf->Image($lp_source, $lv_rect[0], $lv_rect[1], $lv_rect[2], $lv_rect[3], $lp_type, '', 'T', true, 150, '', false, false, 0, false, false, false);
    }
    return true;
  };

  $lv_placeimage = function($lp_path, $lp_area, $lp_type='') use ($lv_renderimage, $lv_jpegorientation){
    $lv_info = @getimagesize($lp_path);
    if($lv_info===false){
      return false;
    }
    $lv_imgtype = strtoupper($lp_type);
    if($lv_imgtype==='JPEG'){
      $lv_imgtype = 'JPG';
    }
    $lv_rotation = 0;
    if($lv_imgtype==='JPG'){
      $lv_orientation = $lv_jpegorientation($lp_path);
      // Los angulos de Rotate() en TCPDF tienen sentido inverso al EXIF.
      $lv_rotation = ($lv_orientation===3?180:($lv_orientation===6?270:($lv_orientation===8?90:0)));
    }
    if($lv_rotation===0 && $lv_info[0]>$lv_info[1]){
      $lv_rotation = 90;
    }
    return $lv_renderimage($lp_path, $lv_info[0], $lv_info[1], $lp_area, $lv_imgtype, $lv_rotation);
  };

  $lv_placeimageblob = function($lp_image, $lp_area) use ($lv_renderimage){
    if(!isset($lp_image['data'], $lp_image['width'], $lp_image['height'])){
      return false;
    }
    $lv_rotation = ($lp_image['width']>$lp_image['height']?90:0);
    return $lv_renderimage('@'.$lp_image['data'], $lp_image['width'], $lp_image['height'], $lp_area, 'JPG', $lv_rotation);
  };

  $lv_placedocximage = function($lp_image, $lp_area) use ($lv_renderimage){
    if(!isset($lp_image['data'], $lp_image['width'], $lp_image['height'], $lp_image['imagetype'])){
      return false;
    }
    return $lv_renderimage(
      '@'.$lp_image['data'],
      $lp_image['width'],
      $lp_image['height'],
      $lp_area,
      $lp_image['imagetype'],
      0
    );
  };

  $lv_splitdocxtext = function($lp_text, $lp_width, $lp_height) use ($pdf){
    $lv_pages = array();
    $lv_current = '';
    $lv_lines = preg_split('/\R/u', str_replace("\r", '', (string)$lp_text));
    if(!is_array($lv_lines)){
      $lv_lines = array((string)$lp_text);
    }

    foreach($lv_lines as $lv_line){
      $lv_candidate = ($lv_current===''?$lv_line:$lv_current."\n".$lv_line);
      if($pdf->getStringHeight($lp_width, $lv_candidate, false, true, '', 1)<=$lp_height){
        $lv_current = $lv_candidate;
        continue;
      }

      if($lv_current!==''){
        $lv_pages[] = $lv_current;
        $lv_current = '';
      }
      if($pdf->getStringHeight($lp_width, $lv_line, false, true, '', 1)<=$lp_height){
        $lv_current = $lv_line;
        continue;
      }

      $lv_words = preg_split('/\s+/u', trim($lv_line));
      $lv_segment = '';
      foreach($lv_words as $lv_word){
        $lv_wordcandidate = ($lv_segment===''?$lv_word:$lv_segment.' '.$lv_word);
        if($lv_segment!=='' && $pdf->getStringHeight($lp_width, $lv_wordcandidate, false, true, '', 1)>$lp_height){
          $lv_pages[] = $lv_segment;
          $lv_segment = $lv_word;
        }else{
          $lv_segment = $lv_wordcandidate;
        }
      }
      $lv_current = $lv_segment;
    }

    if($lv_current!=='' || count($lv_pages)===0){
      $lv_pages[] = $lv_current;
    }
    return $lv_pages;
  };

  $lv_renderdocxtext = function($lp_text, $lp_area) use ($pdf){
    $pdf->SetTextColor(23, 56, 95);
    $pdf->SetFont('helvetica', 'B', 5.8);
    $pdf->SetXY($lp_area[0]+3, $lp_area[1]+2.5);
    $pdf->Cell($lp_area[2]-6, 3, 'CONTENIDO DEL DOCUMENTO', 0, 0, 'L');
    $pdf->SetTextColor(34, 48, 68);
    $pdf->SetFont('helvetica', '', 7.2);
    $pdf->MultiCell(
      $lp_area[2]-6,
      $lp_area[3]-9,
      $lp_text,
      0,
      'L',
      false,
      1,
      $lp_area[0]+3,
      $lp_area[1]+6,
      true,
      0,
      false,
      true,
      $lp_area[3]-9,
      'T',
      false
    );
    return true;
  };

  $lv_isheic = function($lp_path, $lp_mimetype='', $lp_filename=''){
    $lv_mimetype = strtolower(trim((string)$lp_mimetype));
    $lv_extension = strtolower(pathinfo((string)$lp_filename, PATHINFO_EXTENSION));
    if(in_array($lv_mimetype, array('image/heic', 'image/heif', 'image/heic-sequence', 'image/heif-sequence'), true)
      || in_array($lv_extension, array('heic', 'heif'), true)){
      return true;
    }

    $lv_header = @file_get_contents($lp_path, false, null, 0, 64);
    if($lv_header===false || strlen($lv_header)<12 || substr($lv_header, 4, 4)!=='ftyp'){
      return false;
    }
    $lv_brands = array('heic', 'heix', 'hevc', 'hevx', 'heim', 'heis', 'mif1', 'msf1');
    for($lv_pos=8; ($lv_pos+4)<=strlen($lv_header); $lv_pos+=4){
      if(in_array(substr($lv_header, $lv_pos, 4), $lv_brands, true)){
        return true;
      }
    }
    return false;
  };

  foreach($vew_fleslt as $lv_attachment){
    $lv_path = $lv_attachment['flepth']??'';
    $lv_filename = $lv_attachment['fledata']['flenme']??'';
    $lv_mimetype = strtolower($lv_attachment['fledata']['fletyp']??'');
    if($lv_path==='' || !file_exists($lv_path)){
      $lv_attachmenterrors[] = $lv_filename.': archivo no disponible';
      continue;
    }

    $lv_signature = '';
    $lv_flehandle = @fopen($lv_path, 'rb');
    if($lv_flehandle!==false){
      $lv_signature = fread($lv_flehandle, 5);
      fclose($lv_flehandle);
    }
    $lv_ispdf = ($lv_mimetype==='application/pdf' || $lv_signature==='%PDF-');
    $lv_fileextension = strtolower(pathinfo($lv_filename, PATHINFO_EXTENSION));
    $lv_isdocx = (
      $lv_fileextension==='docx'
      || $lv_mimetype==='application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    );

    if($lv_isheic($lv_path, $lv_mimetype, $lv_filename)){
      $lv_attachmenterrors[] = $lv_filename.': HEIC/HEIF requiere una conversión previa a JPG o PDF para incorporarse con TCPDF';
      continue;
    }

    if($lv_isdocx){
      $lv_docxcontent = $lv_extractdocxcontent($lv_path);
      $lv_docxtext = '';
      $lv_docximages = array();
      foreach($lv_docxcontent['blocks'] as $lv_docxblock){
        if(($lv_docxblock['type']??'')==='text'){
          $lv_docxtext .= ($lv_docxtext===''?'':"\n\n").$lv_docxblock['text'];
        }elseif(($lv_docxblock['type']??'')==='image'){
          $lv_docximages[] = $lv_docxblock;
        }
      }

      if($lv_docxtext!==''){
        $pdf->SetFont('helvetica', '', 7.2);
        $lv_textarea = $lv_attachmentplaced?$lv_fullarea:$lv_firstarea;
        $lv_textpages = $lv_splitdocxtext($lv_docxtext, $lv_textarea[2]-6, $lv_textarea[3]-9);
        foreach($lv_textpages as $lv_textpage){
          if($lv_attachmentplaced){
            $lv_addattachmentpage($lv_filename);
            $lv_textarea = $lv_fullarea;
          }else{
            $lv_textarea = $lv_firstarea;
          }
          $lv_renderdocxtext($lv_textpage, $lv_textarea);
          $lv_attachmentplaced = true;
        }
      }

      foreach($lv_docximages as $lv_docximage){
        if($lv_attachmentplaced){
          $lv_addattachmentpage($lv_filename);
          $lv_area = $lv_fullarea;
        }else{
          $lv_area = $lv_firstarea;
        }
        if($lv_placedocximage($lv_docximage, $lv_area)){
          $lv_attachmentplaced = true;
        }
      }

      foreach($lv_docxcontent['errors'] as $lv_docxerror){
        $lv_attachmenterrors[] = $lv_filename.': '.$lv_docxerror;
      }
      continue;
    }

    if($lv_ispdf){
      $lv_pdfimages = $lv_extractpdfimages($lv_path);
      if(count($lv_pdfimages)>0){
        foreach($lv_pdfimages as $lv_pdfimage){
          if($lv_attachmentplaced){
            $lv_addattachmentpage($lv_filename);
            $lv_area = $lv_fullarea;
          }else{
            $lv_area = $lv_firstarea;
          }
          if($lv_placeimageblob($lv_pdfimage, $lv_area)){
            $lv_attachmentplaced = true;
          }
        }
      }else{
        $lv_attachmenterrors[] = $lv_filename.': el PDF no contiene una imagen JPEG compatible';
      }
      continue;
    }

    if(!$lv_ispdf){
      if($lv_attachmentplaced){
        $lv_addattachmentpage($lv_filename);
        $lv_area = $lv_fullarea;
      }else{
        $lv_area = $lv_firstarea;
      }
      $lv_imginfo = @getimagesize($lv_path);
      $lv_imgtype = '';
      if($lv_imginfo!==false && isset($lv_imginfo[2]) && function_exists('image_type_to_extension')){
        $lv_imgtype = image_type_to_extension($lv_imginfo[2], false);
      }
      if($lv_placeimage($lv_path, $lv_area, $lv_imgtype)){
        $lv_attachmentplaced = true;
        continue;
      }
      $lv_attachmenterrors[] = $lv_filename.': formato de imagen no reconocido';
    }
  }

  if(!$lv_attachmentplaced){
    $pdf->SetDrawColor(182, 195, 209);
    $pdf->SetLineStyle(array('width'=>0.2, 'dash'=>'2,2', 'color'=>array(182, 195, 209)));
    $pdf->RoundedRect($lv_firstarea[0]+18, $lv_firstarea[1]+5, $lv_firstarea[2]-36, $lv_firstarea[3]-10, 2, '1111', 'D');
    $pdf->SetLineStyle(array('width'=>0.2, 'dash'=>0, 'color'=>array(182, 195, 209)));
    $pdf->SetTextColor(104, 119, 139);
    $pdf->SetFont('helvetica', 'B', 8.5);
    $pdf->SetXY($lv_firstarea[0], $lv_firstarea[1]+($lv_firstarea[3]/2)-4);
    $pdf->Cell($lv_firstarea[2], 4, count($vew_fleslt)>0?'NO SE PUDO INCORPORAR EL ADJUNTO':'SIN DOCUMENTACIÓN ADJUNTA', 0, 0, 'C');
    if(count($lv_attachmenterrors)>0){
      $pdf->SetFont('helvetica', '', 5.8);
      $pdf->SetXY($lv_firstarea[0]+20, $lv_firstarea[1]+($lv_firstarea[3]/2)+1);
      $pdf->MultiCell($lv_firstarea[2]-40, 12, implode("\n", $lv_attachmenterrors), 0, 'C', false, 1, '', '', true, 0, false, true, 12, 'T', true);
    }
  }

  // Numeracion discreta de todas las paginas del documento final.
  $lv_totalpages = $pdf->getNumPages();
  for($lv_pagenum=1; $lv_pagenum<=$lv_totalpages; $lv_pagenum++){
    $pdf->setPage($lv_pagenum);
    $pdf->SetTextColor(104, 119, 139);
    $pdf->SetFont('helvetica', '', 5.5);
    $pdf->SetXY(172, 291.5);
    $pdf->Cell(26, 3, 'Página '.$lv_pagenum.' de '.$lv_totalpages, 0, 0, 'R');
  }

  $pdf->Output('ficha_evolucion_'.$vew_data->evlcod.'.pdf', 'I');
?>
