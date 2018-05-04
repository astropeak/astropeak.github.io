# -*- coding:ascii -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
STOP_RENDERING = runtime.STOP_RENDERING
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 10
_modified_time = 1525426981.836458
_enable_loop = True
_template_filename = '/Users/astropeak/python-virtualenv/nikola/lib/python3.6/site-packages/nikola/data/themes/bootstrap3/templates/slides.tmpl'
_template_uri = 'slides.tmpl'
_source_encoding = 'ascii'
_exports = ['content']


def render_body(context,**pageargs):
    __M_caller = context.caller_stack._push_frame()
    try:
        __M_locals = __M_dict_builtin(pageargs=pageargs)
        carousel_id = context.get('carousel_id', UNDEFINED)
        enumerate = context.get('enumerate', UNDEFINED)
        range = context.get('range', UNDEFINED)
        len = context.get('len', UNDEFINED)
        def content():
            return render_content(context._locals(__M_locals))
        slides_content = context.get('slides_content', UNDEFINED)
        __M_writer = context.writer()
        if 'parent' not in context._data or not hasattr(context._data['parent'], 'content'):
            context['self'].content(**pageargs)
        

        __M_writer('\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_content(context,**pageargs):
    __M_caller = context.caller_stack._push_frame()
    try:
        carousel_id = context.get('carousel_id', UNDEFINED)
        enumerate = context.get('enumerate', UNDEFINED)
        range = context.get('range', UNDEFINED)
        len = context.get('len', UNDEFINED)
        def content():
            return render_content(context)
        slides_content = context.get('slides_content', UNDEFINED)
        __M_writer = context.writer()
        __M_writer('\n<div id="')
        __M_writer(str(carousel_id))
        __M_writer('" class="carousel slide">\n    <ol class="carousel-indicators">\n')
        for i in range(len(slides_content)):
            if i == 0:
                __M_writer('            <li data-target="#')
                __M_writer(str(carousel_id))
                __M_writer('" data-slide-to="')
                __M_writer(str(i))
                __M_writer('" class="active"></li>\n')
            else:
                __M_writer('            <li data-target="#')
                __M_writer(str(carousel_id))
                __M_writer('" data-slide-to="')
                __M_writer(str(i))
                __M_writer('"></li>\n')
        __M_writer('    </ol>\n    <div class="carousel-inner">\n')
        for i, image in enumerate(slides_content):
            if i == 0:
                __M_writer('                <div class="item active"><img src="')
                __M_writer(str(image))
                __M_writer('" alt="" style="margin: 0 auto 0 auto;"></div>\n')
            else:
                __M_writer('                <div class="item"><img src="')
                __M_writer(str(image))
                __M_writer('" alt="" style="margin: 0 auto 0 auto;"></div>\n')
        __M_writer('    </div>\n    <a class="left carousel-control" href="#')
        __M_writer(str(carousel_id))
        __M_writer('" data-slide="prev"><span class="icon-prev"></span></a>\n    <a class="right carousel-control" href="#')
        __M_writer(str(carousel_id))
        __M_writer('" data-slide="next"><span class="icon-next"></span></a>\n</div>\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


"""
__M_BEGIN_METADATA
{"filename": "/Users/astropeak/python-virtualenv/nikola/lib/python3.6/site-packages/nikola/data/themes/bootstrap3/templates/slides.tmpl", "uri": "slides.tmpl", "source_encoding": "ascii", "line_map": {"16": 0, "32": 24, "38": 1, "49": 1, "50": 2, "51": 2, "52": 4, "53": 5, "54": 6, "55": 6, "56": 6, "57": 6, "58": 6, "59": 7, "60": 8, "61": 8, "62": 8, "63": 8, "64": 8, "65": 11, "66": 13, "67": 14, "68": 15, "69": 15, "70": 15, "71": 16, "72": 17, "73": 17, "74": 17, "75": 20, "76": 21, "77": 21, "78": 22, "79": 22, "85": 79}}
__M_END_METADATA
"""
