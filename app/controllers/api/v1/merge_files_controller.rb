class Api::V1::MergeFilesController < ApplicationController
  http_basic_authenticate_with name: USER_NAME, password: SECRET_KEY
  require 'csv'
  require 'docx'

  def merge
    CSV.open(params[:csv].path, 'r') { |csv| @file_col_width =  csv.first.length }
    add_header_to_csv

    word_file_path = params[:word].path
    word_file=Docx::Document.open(word_file_path)
    word_file.each_paragraph do |p|
      paragraph = p.text
      if !paragraph.blank?
        tag_text = paragraph[/\<!(.*?)>/,1].split("")
        
        column_and_row = []
        column_and_row << tag_text.last
        column_and_row << tag_text[5]

        new_string = get_data_from_csv(column_and_row) if !column_and_row.blank?

        if new_string.present?
          new_para = '<!'+paragraph[/\<!(.*?)>/,1]+'>'+' '+new_string
          p.text = new_para
        end
      end

    end
    a = word_file.save('tests.docx')


    @filename ="#{Rails.root}/tests.docx"
    send_file(@filename ,
      :type => 'application/pdf/docx/html/htm/doc',
      :disposition => 'attachment')
  end

  def get_data_from_csv(column_and_row)
    file = CSV.read(params[:csv].path, headers: true, header_converters: :symbol, converters: :all)
    file.by_col[column_and_row[0].to_sym][column_and_row[1].to_i-1]
  end

  def add_header_to_csv
    headers = ["a"]

    for i in 2..@file_col_width
      next_header = successor(headers.last)
      headers << next_header
    end


    #Adding header to file
    CSV.open(params[:csv].path + '.tmp', 'w', write_headers: true, headers: headers) do |dest|
      # Transpose original data
      CSV.open(params[:csv].path) do |source|
        source.each do |row|
          dest << row
        end
      end
    end
    # Swap new version for old
    File.rename(params[:csv].path + '.tmp', params[:csv].path)
  end

  def successor(e)
    e.succ
  end
end
